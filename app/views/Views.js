import React, { Component } from 'react'
import {
    AppRegistry, View, Text, Dimensions, Image, StyleSheet
  } from 'react-native'
import { createStore, applyMiddleware, combineReducers, compose } from 'redux'
import { Provider } from 'react-redux'
import { composeWithDevTools } from 'redux-devtools-extension'
import { combineEpics, createEpicMiddleware } from 'redux-observable'

import TabNavigator from 'react-native-tab-navigator'
import Icon from 'react-native-vector-icons/FontAwesome'
// import { StackNavigator } from 'react-navigation'

import * as reducers from '../reducers'
import { epics } from '../epics'

import TKContainer from '../containers/TKContainer'
import SecKillContainer from '../containers/SecKillContainer'

const deviceW = Dimensions.get('window').width

const basePx = 375

function px2dp(px) {
  return px *  deviceW / basePx
}

const epicMiddleware = createEpicMiddleware(
    combineEpics(...epics)
)
  
const reducer = combineReducers(reducers)

const store = createStore(
    reducer,
    composeWithDevTools(
        compose(
            applyMiddleware(epicMiddleware)
        )
    )
)

class TK extends Component {
    render () {
        console.log('Views ==>> TK')
        return (
            <Provider store={store}>
                <TKContainer/>
            </Provider>
        )
    }
}

class SecKill extends Component {
    render () {
        return (
            <View style={{flex: 1, backgroundColor: 'red'}}>
            </View>
        )
    }
}

export  class App extends Component {
    state= {
      selectedTab: 'tk'
    };

    render() {
        console.log('TabDemo')
        return (
            <TabNavigator style={styles.container}>
            <TabNavigator.Item
            selected={this.state.selectedTab === 'tk'}
            title="首页"
            selectedTitleStyle={{color: "green"}}
            renderIcon={() => <Image style={{width: 22, height:22, backgroundColor:'red'}}/>}
            renderSelectedIcon={() => <Image style={{width: 22, height:22, backgroundColor:'green'}}/>}
            onPress={() => this.setState({selectedTab: 'tk'})}>
            <TK/>
            </TabNavigator.Item>
            <TabNavigator.Item
            selected={this.state.selectedTab === 'secKill'}
            title="秒杀"
            selectedTitleStyle={{color: "green"}}
            renderIcon={() => <Image style={{width: 22, height:22, backgroundColor:'red'}}/>}
            renderSelectedIcon={() => <Image style={{width: 22, height:22, backgroundColor:'green'}}/>}
            onPress={() => this.setState({selectedTab: 'secKill'})}>
            <SecKill/>
            </TabNavigator.Item>
        </TabNavigator>

      );
    }
  }

  const styles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      backgroundColor: '#F5FCFF',
    }
})
  

