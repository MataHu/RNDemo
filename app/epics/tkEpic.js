import 'rxjs'
import { Observable } from 'rxjs/Rx'
import { NativeModules, Platform, NetInfo } from 'react-native'
import { combineEpics } from 'redux-observable'

import * as actions from '../actions/TKActions'
import * as actionsConst from '../actionconst/tk'

import { TKApi } from '../apis/api'

function TKInitEpic (action$) {
    return action$.ofType(actionsConst.TK_START_LOADING)
        .mergeMap((action) =>
        Observable.zip(
            Observable.of(action.categoryId),
            Observable.of(action.limit),
            Observable.of(action.start),            
            (categoryId, limit, start) => {
            return {categoryId, limit, start}
            }
        ).flatMap(
            it => {
                console.log('TKInitEpic init')
                return Observable.from(TKApi(it))
            }
        ).map(it => {
            if (it.success === true) {
                console.log('TKInitEpic success', it)
                return actions.tkData(it.list) 
            }else {
                console.log('TKInitEpic error 请求失败')                    
                return Observable.of(actions.error('请求失败'))                
            }
        }).catch(error => {
            console.log('TKInitEpic error', error)    
            return Observable.of(actions.error(error))                
        })
    )
}

export default combineEpics(TKInitEpic)
  

