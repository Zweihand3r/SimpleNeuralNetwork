Qt.include('Matrix.js')

const enableLogs = false

function train(inputs, outputs, steps, nodes) {
    var weights = []

    if (inputs === undefined || outputs === undefined) {
        console.log("Missing Inputs or outputs")
    }
    else {
        if (nodes === undefined) nodes = 4
        if (steps === undefined) steps = 100

        if (enableLogs) {
            console.log("Nodes set to: " + nodes)
            console.log("Steps set to: " + steps)
        }

        var weights_1 = random(inputs[0].length, nodes)
        var weights_2 = random(nodes, outputs[0].length)

        if (enableLogs) {
            printArray(inputs, "Inputs:")
            printArray(outputs, "Outputs:")
            console.log("Starting training session")
        }

        var startTime = new Date()

        for (var index = 0; index < steps; index++) {
            if (enableLogs) {
                console.log("Step " + (index + 1) + " of " + steps)
            }

            var l0 = inputs.slice()
            var l1 = sigmoid(dot(l0, weights_1))
            var l2 = sigmoid(dot(l1, weights_2))

            var l2_error = subtract(outputs, l2)

            var l2_delta = multiply(l2_error, sigmoidDerivative(l2))
            var l1_error = dot(l2_delta, transpose(weights_2))
            var l1_delta = multiply(l1_error, sigmoidDerivative(l1))

            weights_2 = add(weights_2, dot(transpose(l1), l2_delta))
            weights_1 = add(weights_1, dot(transpose(l0), l1_delta))
        }

        if (enableLogs) {
            printArray(weights_1, "Weights Layer 1")
            printArray(weights_2, "Weights Layer 2")
        }

        weights = [weights_1, weights_2]
    }

    var timeElapsed = (new Date() - startTime) / 1000

    if (enableLogs) {
        console.log("Finished training session in " + Number(timeElapsed).toFixed(3) + " sec")
    }

    return weights
}

function trainBatch(inputs, outputs, weights, steps, nodes) {
    if (inputs === undefined || outputs === undefined) {
        console.log("Missing Inputs or outputs")
    }
    else {
        if (nodes === undefined) nodes = 4
        if (steps === undefined) steps = 100

        if (enableLogs) {
            console.log("Nodes set to: " + nodes)
            console.log("Steps set to: " + steps)
        }

        var weights_1 = weights[0]
        var weights_2 = weights[1]

        if (enableLogs) {
            printArray(inputs, "Inputs:")
            printArray(outputs, "Outputs:")
            console.log("Starting training session")
        }

        var startTime = new Date()

        for (var index = 0; index < steps; index++) {
            if (enableLogs) {
                console.log("Step " + (index + 1) + " of " + steps)
            }

            var l0 = inputs.slice()
            var l1 = sigmoid(dot(l0, weights_1))
            var l2 = sigmoid(dot(l1, weights_2))

            var l2_error = subtract(outputs, l2)

            var l2_delta = multiply(l2_error, sigmoidDerivative(l2))
            var l1_error = dot(l2_delta, transpose(weights_2))
            var l1_delta = multiply(l1_error, sigmoidDerivative(l1))

            weights_2 = add(weights_2, dot(transpose(l1), l2_delta))
            weights_1 = add(weights_1, dot(transpose(l0), l1_delta))
        }

        if (enableLogs) {
            printArray(weights_1, "Weights Layer 1")
            printArray(weights_2, "Weights Layer 2")
        }
    }

    var timeElapsed = (new Date() - startTime) / 1000

    if (enableLogs) {
        console.log("Finished training session in " + Number(timeElapsed).toFixed(3) + " sec")
    }

    return [weights_1, weights_2]
}

function trainStep(inputs, outputs, weights, nodeCount) {
    var weights_1 = weights[0]
    var weights_2 = weights[1]

    var l0 = inputs
    var l1 = sigmoid(dot(l0, weights_1))
    var l2 = sigmoid(dot(l1, weights_2))

    var l2_error = subtract(outputs, l2)

    var l2_delta = multiply(l2_error, sigmoidDerivative(l2))
    var l1_error = dot(l2_delta, transpose(weights_2))
    var l1_delta = multiply(l1_error, sigmoidDerivative(l1))

    weights_2 = add(weights_2, dot(transpose(l1), l2_delta))
    weights_1 = add(weights_1, dot(transpose(l0), l1_delta))

    return [weights_1, weights_2]
}

function predict(inputs, weights) {
    var weights_1 = weights[0]
    var weights_2 = weights[1]

    inputs = [inputs]

    var l1 = sigmoid(dot(inputs, weights_1))
    var l2 = sigmoid(dot(l1, weights_2))

    return l2[0]
}

function sigmoid(x) {
    var res = []
    x.forEach(function(arr) {
        var res_arr = []
        arr.forEach(function(num) {
            res_arr.push(1 / (1 + Math.exp(-num)))
        })
        res.push(res_arr)
    })
    return res
}

function sigmoidDerivative(x) {
    var res_ = []
    x.forEach(function(arr) {
        var res_arr = []
        arr.forEach(function(num) {
            res_arr.push(1 - num)
        })
        res_.push(res_arr)
    })
    return multiply(x, res_)
}

function random(rows, cols) {
    var res = []
    for (var index = 0; index < rows; index++) {
        var arr = []
        for (var index_ = 0; index_ < cols; index_++) {
            arr.push((Math.random() * 2) - 1)
        }
        res.push(arr)
    }
    return res
}

function initializeWeights(type, inputCount, outputCount, nodeCount) {
    if (type === undefined) type = "random"

    switch (type) {
    case "random":
        var weights_1 = random(inputCount, nodeCount)
        var weights_2 = random(nodeCount, outputCount)
        break
    }

    return [weights_1, weights_2]
}

function printArray(arr, title) {
    if (title) { console.log(title) }
    arr.forEach(function(item) {
        console.log(item)
    })
}
