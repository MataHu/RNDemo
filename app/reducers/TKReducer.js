import * as actions from '../actionconst/tk'

const initialState = {
    listData: [],
    isRefreshing: true,
    isLoadingMore: false,
    hasMoreData: false,
    start: 0,
}

export default function tkReducer (state = initialState, action = {}) {
    switch (action.type) {
        case actions.TK_START_LOADING:
        console.log('tkReducer ==>>TK_START_LOADING')
            return {
                ...state
            }
        case actions.TK_DATA:
        console.log('tkReducer ==>>TK_DATA', action.listData, action.hasMoreData)
            return {
                ...state,
                listData: action.listData,
                isRefreshing: false,
                isLoadingMore: false,
                hasMoreData: action.hasMoreData,
                start: state.start + 10,
            }
        default:
            return state    
    }
}