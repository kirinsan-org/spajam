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
}

export class SeasonFactory {
  static spring(): Season {
    return {
      type: 'spring',
      state: State.Born,
      pain: 0,
      life: 1000,
      lastUpdate: 0,
      averageTemperature: 20
    }
  }

  static summer(): Season {
    return {
      type: 'summer',
      state: State.Born,
      pain: 0,
      life: 1000,
      lastUpdate: 0,
      averageTemperature: 30
    }
  }

  static autumn(): Season {
    return {
      type: 'autumn',
      state: State.Born,
      pain: 0,
      life: 1000,
      lastUpdate: 0,
      averageTemperature: 20
    }
  }

  static winter(): Season {
    return {
      type: 'winter',
      state: State.Born,
      pain: 0,
      life: 1000,
      lastUpdate: 0,
      averageTemperature: 10
    }
  }
}
