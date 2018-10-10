/*
  * From Becoming Human AI
  * https://becominghuman.ai/making-a-simple-neural-network-2ea1de81ec20
  *
  * I dont think this is machine learning from what i have read so far. But then again what do
  * I know. Need to adjust weights
  */


var inputs = [0,1,0,0]
var weights = [0,0,0,0]
var desiredResult = 1
var learningRate = 0.2
var trials = 6

function evaluate() {
    console.log("Inputs: " + inputs)

    console.log("Weights: " + weights)
    console.log("Output: " + evaluateNeuralNetwork(inputs, weights))

    console.log("Training...")
    train(trials)

    console.log("Weights: " + weights)
}

function evaluateNeuralNetwork(inputVector, weightVector) {
    var result = 0
    inputVector.forEach(function(inputValue, weightIndex) {
        var layerValue = inputValue * weightVector[weightIndex]
        result += layerValue
    })
    return result.toFixed(2)
}

function evaluateNeuralNetError(desired, actual) {
    return (desired - actual)
}

function learn(inputVector, weightVector) {
    weightVector.forEach(function(weight, index, weights) {
        if (inputVector[index] > 0) {
            weights[index] = weight + learningRate
        }
    })
}

function train(trials) {
    for (var i = 0; i < trials; i++) {
        var neuralNetResult = evaluateNeuralNetwork(inputs, weights)
        learn(inputs, weights)
    }
}
