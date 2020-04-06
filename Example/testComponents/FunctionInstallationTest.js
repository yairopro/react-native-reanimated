import React from 'react';
import Animated, { useSharedValue, useEventWorklet, useAnimatedStyle } from 'react-native-reanimated';
import { View, Text } from 'react-native';

const FunctionInstallationTest = () => {
    ;(() => {
        console.log('testing assign');
        Animated.work()
    })();

    return (
        <View>
            <Text>Testing...</Text>
        </View>
    )
}

export default FunctionInstallationTest