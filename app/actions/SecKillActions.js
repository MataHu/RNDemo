import * as actions from '../actionconst/secKill'

export const secKillStartLoading = (start) => {
  console.log('action ==> TK_INIT ')
  return {
    type: actions.SECKILL_START_LOADING,
    isSeckill: true,
    limit: 10,
    start
  }
}