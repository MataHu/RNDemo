import React, { Component } from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';

import * as actions from '../actions/SecKillActions';
import SecKillList from '../components/SecKillComponent'

class SecKillContainer extends Component {
  render () {
    console.log('SecKillContainer', this.props.actions)
    const {actions} = this.props
    return (
      <SecKillList
        {...actions} />
    )
  }
}

const mapStateToProps = (state) => {
  console.log('mapStateToPro' + state)
  return {
    listData:[]
  }
}

const mapDispatchToProps = (dispatch) => ({
  actions: bindActionCreators({...actions}, dispatch)
})

export default connect(mapStateToProps, mapDispatchToProps)(SecKillContainer)
