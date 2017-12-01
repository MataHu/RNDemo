import React from 'react'
import {
  View, Text, FlatList, RefreshControl, Dimensions, Image
} from 'react-native'
import PageComponent from '../public/BackPageComponent'
let deviceWidth = Dimensions.get('window').width

export default class TKComponent extends PageComponent {
  componentDidMount () {
    console.log('componentDidMount ==>> tkInit')
    this.props.tkInit()    
  }

  render () {
    const {listData, isRefreshing} = this.props
    console.log('Component ==>> render', listData)
    
    if (listData.length > 0) {
      return (
        <FlatList
        style={{flex: 1}}
        data={listData}
        renderItem={(e) => this.getItemCompt(e)}
        ListFooterComponent={(e) => this.renderLoadMoreFooter(e)}      
        onEndReachedThreshold={0.1}
        onEndReached={this.onEndReached}
        removeClippedSubviews={false}
        backgroundColor={'#f2f2f2'}
        refreshControl={
          <RefreshControl
            onRefresh={this.onRefresh}
            color="#ccc"
            refreshing={isRefreshing}
            colors={['#ff0000', '#ff0000', '#ff0000']}
          />
        }/>)
    }else {
      return <View/>
    }
  }

  onRefresh = () => {
    this.props.tkInit()    
  }

  getItemCompt = ({item, index}) => {
    console.log('getItemCompt', item)
    return <View style={{height: 140, width: deviceWidth}}>
      <Image style={{height: 140, width: 140}} source={{uri: item.pic}}/>
      <Text style={{fontSize:15}}>{item.title}</Text>
    </View>
  }

  onEndReached = () => {
    console.log('onEndReached')
    const {start, hasMoreData, isRefreshing, tkGetMoreData} = this.props
    if (!isRefreshing) {
      if (hasMoreData) {
        tkGetMoreData(start)
      }
    }
  }
  renderLoadMoreFooter (e) {
    const {isLoadingMore, hasMoreData, listData} = this.props
    if (isLoadingMore && listData && listData.length > 0) {
      return <Text style={{width: deviceWidth, height: 40, alignSelf: 'center', textAlign: 'center', color: '#313131', fontSize: 15, lineHeight: 40}}
                  numberOfLines={1}>{'正在加载...'}</Text>
    }else {
      return <View/>
    }
  }
}