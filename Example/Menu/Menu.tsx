import React from 'react';
import { StyleSheet, View } from 'react-native';

import { useSharedValue, useWorklet } from 'react-native-reanimated';

import Screen from './Screen';
import Profile from './Profile';
import { width } from './Content';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black',
  },
  layer: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
  },
});

const MIN = -width * Math.tan(Math.PI / 4);

export default () => {
  const isOpen = useAnimatedValue(false);

  return (
    <View style={styles.container}>
      <Screen isOpen={isOpen} />
      <View style={styles.layer} pointerEvents="box-none">
        <Profile isOpen={isOpen} />
      </View>
    </View>
  );
};
