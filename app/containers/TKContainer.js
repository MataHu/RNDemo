import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as actions from '../actions/TKActions';
import TKList from '../components/TKComponent'

class TKContainer extends Component {
  render () {
    const {actions, listData, start, isRefreshing, isLoadingMore, hasMoreData} = this.props
    return (
      <TKList
        listData={listData}
        start={start}
        isRefreshing={isRefreshing}
        isLoadingMore={isLoadingMore}
        hasMoreData={hasMoreData}
        {...actions} />
    )
  }
}

const mapStateToProps = (state) => {
  console.log('TKContainer ==>> mapStateToProps')
  return {
    listData: state.tkReducer.listData,
    start: state.tkReducer.start,
    isRefreshing: state.tkReducer.isRefreshing,
    isLoadingMore: state.tkReducer.isLoadingMore,
    hasMoreData: state.tkReducer.hasMoreData
  }
}

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators({...actions}, dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(TKContainer)
