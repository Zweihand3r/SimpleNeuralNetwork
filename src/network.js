import { generateId } from './util.js'

class Neuron {
  constructor() {
    this.id = generateId()
    this.inputNeurons = []
    this.outputNeurons = []
    this.activation = 0
    this.weights = []
    this.bias = 0
  }

  forward(ni) {
    if (this.inputNeurons.length > 0) {
      let weightedSum = 0
      for (let i = 0; i < this.inputNeurons.length; i++) {
        const inputNeuron = this.inputNeurons[i]
        weightedSum += inputNeuron.activation * inputNeuron.weights[ni]
      }
      this.activation = weightedSum + this.bias
    }
  }
}

export class Layer {
  constructor(count, prevLayer) {
    this.neurons = []
    for (let i = 0; i < count; i++) {
      this.neurons.push(new Neuron())
    }

    if (prevLayer) {
      this.prevLayer = prevLayer
      for (let i = 0; i < this.neurons.length; i++) {
        this.neurons[i].inputNeurons = this.prevLayer.neurons
      }

      this.prevLayer.nextLayer = this
      for (let i = 0; i < this.prevLayer.neurons.length; i++) {
        this.prevLayer.neurons[i].outputNeurons = this.neurons
        this.prevLayer.neurons[i].weights = Array(this.neurons.length).fill(0)
      }
    } else {
      this.prevLayer = []
      this.nextLayer = []
    }
  }

  setInputs(inputs) {
    if (inputs.length === this.neurons.length) {
      for (let i = 0; i < inputs.length; inputs++) {
        this.neurons[i].activation = inputs[i]
      }
    }
  }

  forward() {
    for (let i = 0; i < this.neurons.length; i++) {
      this.neurons[i].forward(i)
    }
  }
}