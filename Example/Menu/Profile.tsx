import React from 'react';
import { PanGestureHandler, State } from 'react-native-gesture-handler';
import Animated, {
  useEventWorklet,
  useSharedValue,
  useWorklet,
} from 'react-native-reanimated';

import { alpha, perspective } from './Constants';
import Content, { width } from './Content';

const MIN = -width * Math.tan(alpha);
const MAX = 0;
const PADDING = 100;

export default ({ isOpen }) => {
  const tilt = useAnimatedValue(0);

  const animatedStyles = useAnimatedStyles(
    function(input) {
      const { isOpen, width, MIN } = input;
      const tilt = input.tilt / 50; // normalize tilt
      return {
        transform: [
          { translateX: isOpen ? tilt * 100 : MIN },
          { translateX: -width / 2 },
          { rotateY: (isOpen ? tilt * 15 : -45) + 'deg' },
          { translateX: width / 2 },
          { scale: isOpen ? 1 : 0.9 },
        ],
      };
    },
    { isOpen, tilt, width, MIN }
  );

  const eventWorklet = useEventWorklet(
    function(event, input) {
      if (this.event.state === 2) {
        const gestureF = Animated.springForce(0, event.translationX);
        const tiltF = Animated.springForce(0, input.tilt);

        input.tilt = input.tilt + gestureF + tiltF;
      } else if (this.event.state === 5) {
        if (input.tilt < -30) {
          input.isOpen = false;
        }
        input.tilt = 0;
      }
    },
    { tilt, isOpen }
  );

  return (
    <PanGestureHandler
      minDist={0}
      onGestureEvent={eventWorklet}
      onHandlerStateChange={eventWorklet}>
      <Animated.View style={animatedStyles}>
        <Content />
      </Animated.View>
    </PanGestureHandler>
  );
};
