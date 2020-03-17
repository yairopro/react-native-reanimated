import React from 'react';
import { Dimensions, StyleSheet, Text, View } from 'react-native';
import Animated from 'react-native-reanimated';

import {
  TouchableOpacity,
  TouchableWithoutFeedback,
} from 'react-native-gesture-handler';
import { perspective } from './Constants';

const { width } = Dimensions.get('window');
const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 16,
    backgroundColor: '#F6F5F9',
  },
  button: {
    borderColor: 'black',
    borderWidth: 2,
    borderRadius: 20,
    padding: 16,
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
  },
});

export default ({ isOpen }) => {
  const panelStyles = useAnimatedStyle(
    function(input) {
      const { isOpen, width } = input;
      return {
        borderRadius: isOpen ? 20 : 0,
        transform: [
          { perspective: 1000 },
          { translateX: width / 2 },
          { rotateY: isOpen ? '-45deg' : '0deg' },
          { translateX: -width / 2 },
          { scale: isOpen ? 0.9 : 1 },
        ],
      };
    },
    { isOpen, width }
  );

  const overlayStyles = useAnimatedStyle(
    function(input) {
      const { isOpen } = input;
      return {
        opacity: isOpen ? 1 : 0,
      };
    },
    { isOpen }
  );

  return (
    <>
      <Animated.View style={[styles.container, panelStyles]}>
        <TouchableOpacity onPress={() => open.set(true)}>
          <View style={styles.button}>
            <Text style={styles.label}>Show Menu</Text>
          </View>
        </TouchableOpacity>
      </Animated.View>
      <Animated.View
        pointerEvents="none"
        style={[
          {
            ...StyleSheet.absoluteFillObject,
            backgroundColor: 'black',
          },
          overlayStyles,
        ]}
      />
    </>
  );
};
