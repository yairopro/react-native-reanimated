const work = () => {
    console.log('function installation works')
}

function assign(left, right) {
    if ((typeof right === 'object') && (!right.value)) {
        for (let key of Object.keys(right)) {
            if (left[key]) {
                assign(left[key], right[key]);
            }
        }
    } else if (Array.isArray(right)) {
        for (let i; i < right.length; i++) {
            assign(left[i], right[i]);
        }
    } else {
        if (left.set) {
            if (right.value) {
                left.set(right.value);
            } else {
                left.set(right);
            }
        }
    }
}

const InstalledFunctions = {
    work,
    assign,
}

export default InstalledFunctions