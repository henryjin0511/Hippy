import React from 'react';
import {
  View,
  ScrollView,
  Text,
  ViewPager,
  StyleSheet,
} from '@hippy/react';
import {
  SquarePagerView,
  TrianglePagerView,
  CirclePagerView,
} from '../../shared/PagerItemView';
import Utils from '../../utils';

const NAV_HEIGHT = 45;
const NAV_WIDTH = 60;

const navStyles = StyleSheet.create({
  container: {
    height: NAV_HEIGHT,
    paddingLeft: 4,
    flexDirection: 'row',
    backgroundColor: '#ffffff',
    borderBottomColor: '#E5E5E5',
    borderBottomWidth: 1,
    borderStyle: 'solid',
  },
  scroll: {
    flex: 1,
    height: NAV_HEIGHT - 1,
  },
  navItem: {
    // marginRight: 20,
    // width: NAV_WIDTH,
    height: NAV_HEIGHT - 1,
    paddingTop: 13,

    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  navItemInner: {
    marginRight: 20,
    display: 'flex',
    flexDirection: 'row',
  },
  navItemInnerContainer: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
    height: 25,
  },
  navItemText: {
    fontSize: 16,
    lineHeight: 17,
    textAlign: 'center',
    backgroundColor: '#ffffff',
    fontWeight: 400,
    fontFamily: 'PingFang SC'
  },
  navItemTextNormal: {
    color: '#666666',
  },
  navItemTextBlue: {
    fontSize: 18,
    fontWeight: 500,
    color: '#2D73FF',
  },
});


export default class TabHostExample extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      curIndex: 0,
      navList: ['市场', '基金', '圈子', 'NBA', '中超', '英超', '西甲', 'CBA', '澳网', '电影', '本地', '娱乐', '小说', '生活', '直播', '游戏'],
    };
    this.navScrollView = null;
    this.viewPager = null;
    this.onViewPagerChange = this.onViewPagerChange.bind(this);
    this.pressNavItem = this.pressNavItem.bind(this);
    this.scrollSV = this.scrollSV.bind(this);
  }

  static getPage(navItem, idx) {
    switch (idx % 3) {
      case 0:
        return SquarePagerView(navItem);
      case 1:
        return CirclePagerView(navItem);
      case 2:
        return TrianglePagerView(navItem);
      default:
        return null;
    }
  }

  componentDidUpdate() {
    this.scrollSV();
  }

  onViewPagerChange({ position }) {
    this.setState({
      curIndex: position,
    });
  }

  scrollSV() {
    if (this.navScrollView) {
      const {
        curIndex: idx,
        navList,
      } = this.state;
      const navNum = navList.length;
      const navWidth = Utils.getScreenWidth();
      const hNavWidth = navWidth / 2;
      const halfScreenNavNum = hNavWidth / NAV_WIDTH;
      const notOverScreen = (navNum * NAV_WIDTH) < navWidth;
      let scrollX;
      if (idx <= halfScreenNavNum || notOverScreen) {
        scrollX = 0;
      } else if (idx > (navNum - halfScreenNavNum)) {
        scrollX = navNum * NAV_WIDTH - navWidth;
      } else {
        scrollX = idx * NAV_WIDTH - (halfScreenNavNum * NAV_WIDTH) + NAV_WIDTH / 2;
      }
      this.navScrollView.scrollTo({ x: scrollX, y: 0, animated: true });
    }
  }

  pressNavItem(index) {
    this.setState({
      curIndex: index,
    });
    if (this.viewPager) {
      this.viewPager.setPage(index);
    }
  }

  renderNav() {
    const { navList, curIndex } = this.state;
    return (
      <View style={navStyles.container}>
        <ScrollView
          style={navStyles.scroll}
          horizontal
          showsHorizontalScrollIndicator={false}
          ref={(sv) => {
            this.navScrollView = sv;
          }}
        >
          {
            navList.map((v, idx) => (
              <View
                style={navStyles.navItem}
                key={`nav_${v}`}
                activeOpacity={0.5}
                onClick={() => this.pressNavItem(idx)}
              >
                <View style={navStyles.navItemInner}>
                  <View style={navStyles.navItemInnerContainer}>
                    <Text
                      style={[
                        navStyles.navItemText,
                        curIndex === idx ? navStyles.navItemTextBlue : navStyles.navItemTextNormal,
                      ]}
                      numberOfLines={1}
                    >
                      ssssssss看{v}
                    </Text>
                  </View>
                </View>
              </View>
            ))
          }
        </ScrollView>
      </View>
    );
  }

  render() {
    const { navList } = this.state;
    return (
      <View style={{ flex: 1, backgroundColor: '#ffffff' }}>
        {this.renderNav()}
        <ViewPager
          ref={(viewPager) => {
            this.viewPager = viewPager;
          }}
          style={{ flex: 1 }}
          initialPage={0}
          onPageSelected={this.onViewPagerChange}
        >
          {navList.map((v, idx) => TabHostExample.getPage(v, idx))}
        </ViewPager>
      </View>
    );
  }
}
