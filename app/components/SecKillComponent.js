import React from 'react'
import {
  View, Text
} from 'react-native'
import PageComponent from '../public/BackPageComponent'

export default class SecKillComponent extends PageComponent {
  componentDidMount () {
    console.log('componentDidMountINIT')
    // this.props.tkInit()
  }

  render () {
    console.log('render')
    return (
      <View style={{flex: 1, backgroundColor: 'red'}}>
      <Text>lalallala</Text>
      </View>
    )
  }
}