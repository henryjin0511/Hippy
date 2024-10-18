import { Image, StyleSheet, Text, View, Dimensions } from '@hippy/react';
import React from 'react';

// import { CHEVRON_RIGHT, COIN_MIDDLE_ICON } from '@/assets';
// import { Colors, FontSize, STYLES, UNITS } from '@/helper';

const windowSize = Dimensions.get('window');

export default function ViewExpo({
  pointBalance = 0,
}) {
  return (
    <View
      style={styles.headerContent}
    >
      <Image source={{ uri: 'http://placehold.it/100' }} style={styles.pointIcon} />
      <Text style={styles.pointNumber}>{pointBalance}</Text>
      <View
        style={styles.pointAction}
      >
        <Text style={styles.pointActionText}>兑换记录</Text>
        <Image source={{ uri: 'http://placehold.it/100' }} style={styles.pointActionIcon} />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  headerContent: {
    marginTop: 18,
    height: 60,
    paddingHorizontal: 16,
    width: windowSize.width - 36,
    flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
    backgroundColor: '#ffffff',
    borderRadius: 12,
    // ...STYLES.shadowMain(10),
  },
  pointIcon: {
    width: 24,
    height: 24,
  },
  pointNumber: {
    flex: 1,
    fontSize: 18,
    fontWeight: 'bold',
    lineHeight: 19.0,
    // ...STYLES.fontMain(FontSize.Xxl, 'bold'),
    // ...STYLES.notoSans,
    marginLeft: 6,
  },
  pointAction: {
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
  },
  pointActionText: {
    // ...STYLES.fontLight(FontSize.Md),
    flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
  },
  pointActionIcon: {
    width: 16,
    height: 16,
    marginLeft: 2,
  },
});
