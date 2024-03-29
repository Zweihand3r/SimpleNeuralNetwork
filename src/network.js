import { generateId } from './util.js'

class Neuron {
  constructor() {
    this.id = generateId()
    this.inputNeurons = []
    this.outputNeurons = []
    this.activation = 0
    this.weights = []
    this.bias = 0
    this.activationFunction = activationFunctions.sigmoid
  }

  forward() {
    if (this.inputNeurons.length > 0) {
      let weightedSum = 0
      for (let i = 0; i < this.inputNeurons.length; i++) {
        const inputNeuron = this.inputNeurons[i]
        weightedSum += inputNeuron.activation * this.weights[i]
      }
      this.activation = this.activationFunction(weightedSum + this.bias)
    }
  }

  compute(inputs) {
    let weightedSum = 0
    for (let i = 0; i < inputs.length; i++) {
      weightedSum += inputs[i] * this.weights[i]
    }
    return this.activationFunction(weightedSum + this.bias)
  }
}

class Layer {
  constructor(count, prevLayer) {
    this.neurons = []
    for (let i = 0; i < count; i++) {
      this.neurons.push(new Neuron())
    }

    if (prevLayer) {
      this.prevLayer = prevLayer
      for (let i = 0; i < this.neurons.length; i++) {
        this.neurons[i].inputNeurons = this.prevLayer.neurons
        this.neurons[i].weights = Array(this.prevLayer.neurons.length).fill(0)
      }

      this.prevLayer.nextLayer = this
      for (let i = 0; i < this.prevLayer.neurons.length; i++) {
        this.prevLayer.neurons[i].outputNeurons = this.neurons
      }
    } else {
      this.prevLayer = []
      this.nextLayer = []
    }
  }

  forward() {
    for (let i = 0; i < this.neurons.length; i++) {
      this.neurons[i].forward()
    }
  }

  compute(inputs) {
    const outputs = []
    for (let i = 0; i < this.neurons.length; i++) {
      outputs.push(this.neurons[i].compute(inputs))
    }
    return outputs
  }

  setActivationFunction(func) {
    for (let i = 0; i < this.neurons.length; i++) {
      this.neurons[i].activationFunction = func
    }
  }
}

export class Network {
  constructor() {
    if (arguments.length > 0) {
      this.layers = []
      for (let i in arguments) {
        const count = arguments[i]
        this.addLayer(count)
      }
    } else {
      throw('Invalid arguments')
    }
  }

  get inputLayer() {
    return this.layers[0]
  }

  get outputLayer() {
    return this.layers[this.layers.length - 1]
  }

  addLayer(count) {
    if (this.layers.length === 0) {
      this.layers.push(new Layer(count))
    } else {
      this.layers.push(new Layer(count, this.layers[this.layers.length - 1]))
    }
  }

  setInputs(inputs) {
    if (this.layers.length > 0 && this.layers[0].neurons.length === inputs.length) {
      for (let i = 0; i < inputs.length; i++) {
        this.layers[0].neurons[i].activation = inputs[i]
      } 
    }
  }

  loadWeightsAndBiases(data) {
    for (let li = 0; li < this.layers.length; li++) {
      for (let ni = 0; ni < this.layers[li].neurons.length; ni++) {
        this.layers[li].neurons[ni].weights = data[li][ni].w
        this.layers[li].neurons[ni].bias = data[li][ni].b
      }
    }
  }

  forward() {
    for (let i = 1; i < this.layers.length; i++) {
      this.layers[i].forward()
    }
  }

  compute(inputs) {
    if (this.layers.length > 0 && this.layers[0].neurons.length === inputs.length) {
      for (let i = 1; i < this.layers.length; i++) {
        inputs = this.layers[i].compute(inputs)
      }
      return inputs
    } else {
      return 'Invalid input'
    }
  }

  setActivationFunction(func, layerIndices) {
    if (layerIndices === undefined || layerIndices.length === 0) {
      layerIndices = Array.from(Array(this.layers.length).keys())
    }
    for (let i = 0; i < layerIndices.length; i++) {
      const li = layerIndices[i]
      this.layers[li].setActivationFunction(func)
    }
  }

  // returns the current network weights and biases in json
  print(printInConsole = false) {
    const layers = []
    for (let li = 0; li < this.layers.length; li++) {
      const layer = []
      for (let ni = 0; ni < this.layers[li].neurons.length; ni++) {
        const neuron = this.layers[li].neurons[ni]
        layer.push({
          w: neuron.weights,
          b: neuron.bias
        })
      }
      layers.push(layer)
    }
    if (printInConsole) {
      console.log(layers)
    }
    return layers
  }
}


/* Activation Functions */

export const activationFunctions = {
  sigmoid: x => 1 / (1 + Math.exp(-x)),
  relu: x => Math.max(0, x)
}
