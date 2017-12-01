import { Component } from 'react'
import { Platform, BackHandler, Dimensions } from 'react-native'
// import IOSPopBridge from '../native_modules/IOSPopBridge'
import PubSub from 'pubsub-js'

export default class PageComponent extends Component {
  constructor (props) {
    super(props)
    this.handleBack = this._handleBack.bind(this)
  }

  componentDidMount () {
    BackHandler.addEventListener('hardwareBackPress', () => this._handleBack())
  }

  componentWillUnmount () {
    BackHandler.removeEventListener('hardwareBackPress', () => this._handleBack())
  }

  isIOS () {
    return Platform.OS === 'ios'
  }

  isiPhone5 () {
    return Platform.OS === 'ios' && Dimensions.get('window').width === 320
  }

  isiPhone6 () {
    return Platform.OS === 'ios' && Dimensions.get('window').width === 375
  }

  isiPhonePlus () {
    return Platform.OS === 'ios' && Dimensions.get('window').width === 414
  }

  isAndroid () {
    return Platform.OS === 'android'
  }

  _handleBack (pageType) {
    // const navigator = this.props.navigator
    // if (navigator && navigator.getCurrentRoutes().length > 1) {
    //   navigator.pop()
    //   return true
    // } else {
    //   return false
    // }
  }
}
