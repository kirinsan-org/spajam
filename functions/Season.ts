import * as functions from 'firebase-functions'

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const db = admin.database();

export enum State {
  Born, Live, Dead
}

export interface Season {
  type: string
  state: State
  pain: number
  life: number
  lastUpdate: number
  averageTemperature: number
  emotion: string
}

export class SeasonFactory {
  static async spring(): Promise<Season> {
    return {
      type: 'spring',
      state: State.Born,
      pain: 0,
      life: (await db.ref('defaults/life').once('value')).val(),
      lastUpdate: 0,
      averageTemperature: (await db.ref('defaults/averageTemperature/spring').once('value')).val(),
      emotion: 'shake'
    }
  }

  static async summer(): Promise<Season> {
    return {
      type: 'summer',
      state: State.Born,
      pain: 0,
      life: (await db.ref('defaults/life').once('value')).val(),
      lastUpdate: 0,
      averageTemperature: (await db.ref('defaults/averageTemperature/summer').once('value')).val(),
      emotion: 'shake'
    }
  }

  static async autumn(): Promise<Season> {
    return {
      type: 'autumn',
      state: State.Born,
      pain: 0,
      life: (await db.ref('defaults/life').once('value')).val(),
      lastUpdate: 0,
      averageTemperature: (await db.ref('defaults/averageTemperature/autumn').once('value')).val(),
      emotion: 'shake'
    }
  }

  static async winter(): Promise<Season> {
    return {
      type: 'winter',
      state: State.Born,
      pain: 0,
      life: (await db.ref('defaults/life').once('value')).val(),
      lastUpdate: 0,
      averageTemperature: (await db.ref('defaults/averageTemperature/winter').once('value')).val(),
      emotion: 'shake'
    }
  }
}
