import * as actions from '../actionconst/tk'

export const tkInit = () => {
  console.log('action ==> TK_START_LOADING ')
  return {
    type: actions.TK_START_LOADING,
    categoryId: '',
    limit: 10,
    start: 0
  }
}

export const tkData = (data) => {
  console.log('action ==> tkData ', data)
  return {
    type: actions.TK_DATA,
    listData: data,
    hasMoreData: data.length >= 10,
  }
}

export const tkGetMoreData = () => {
  console.log('action ==> TK_START_LOADING ')
  return {
    type: actions.TK_START_LOADING,
    categoryId: '',
    limit: 10,
    start: 0
  }
}

export const tkMoreData = (data) => {
  console.log('action ==> tkData ', data)
  return {
    type: actions.TK_DATA,
    listData: data
  }
}



export const error = (error) => {
  console.log('action ==> error ', error)
  return {
    type: actions.ERROR,
    error
  }
}