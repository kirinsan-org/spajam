import * as functions from 'firebase-functions'

// const admin = require('firebase-admin');
// admin.initializeApp(functions.config().firebase);

import { State, Season, SeasonFactory } from './Season'

function newSeason(temperature: number): Season {
  if (temperature > 25) {
    return SeasonFactory.summer();
  } else if (temperature < 15) {
    return SeasonFactory.winter();
  } else {
    let today = new Date()
    if (today.getMonth() < 6) {
      return SeasonFactory.spring();
    } else {
      return SeasonFactory.autumn();
    }
  }
}

function updateLife(season: Season, temperature: number) {
  let diff = Math.abs(temperature - season.averageTemperature)
  let now = Date.now()

  if (season.lastUpdate !== 0) {
    // 前回更新からの経過秒数(ただし10秒以上にはならない)
    let dt = Math.min(10, (now - season.lastUpdate) * 0.001);
    season.life -= Math.pow(diff, 2) * dt

    // 平均気温との差が大きいほど、苦痛が大きい
    // this.pain = diff / 100
  }

  season.lastUpdate = now
}

function isLiving(season: Season) {
  return season.life > 0;
}

exports.updateSeason = functions.database.ref('sensor/{sensorId}/temperature')
  .onWrite(async (event) => {

    // センサーのUUID
    const sensorId = event.params.sensorId;

    // センサーから送られてきた値
    const sensorRef = event.data.ref.root.child(`season/${sensorId}`);
    const temperature = event.data.val();

    // 現在の季節を取得
    let season = await sensorRef.once('value');
    let val: Season = season.val();

    // 未設定なら季節を設定して終了
    if (!val) {
      val = newSeason(temperature);
      console.log('create', val);

      return await sensorRef.set(val);
    }

    // 直前の編集が5秒以内の場合は何もしない
    if (val.lastUpdate + 5000 > Date.now()) {
      return;
    }

    // 生まれたばかりだったら、通常状態にする
    if (val.state === State.Born) {
      val.state = State.Live;
    }

    // 温度に合わせてステータスを更新
    updateLife(val, temperature);

    if (val.state === State.Live) {

      // 季節死亡
      if (!isLiving(val)) {
        val.state = State.Dead;
        console.log('DEAD');
      }

    } else if (val.state === State.Dead) {
      // 次の季節に切り替える
      if (val.type === 'spring') {
        val = temperature > 25 ? SeasonFactory.summer() : SeasonFactory.spring()
      } else if (val.type === 'summer') {
        val = temperature < 25 ? SeasonFactory.autumn() : SeasonFactory.summer()
      } else if (val.type === 'autumn') {
        val = temperature < 15 ? SeasonFactory.winter() : SeasonFactory.autumn()
      } else if (val.type === 'winter') {
        val = temperature > 15 ? SeasonFactory.spring() : SeasonFactory.winter()
      } else {
        val = SeasonFactory.spring();
      }
    }

    // 保存
    return await sensorRef.set(val);

  });
