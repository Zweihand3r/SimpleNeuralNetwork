import { initCanvas, drawNetwork } from "./src/canvas.js"
import { initControls } from "./src/controls.js"
import { Layer } from "./src/network.js"

const canvas = document.body.querySelector('#canvas')
canvas.setAttribute('width', window.innerWidth)
canvas.setAttribute('height', window.innerHeight)

const ctx = canvas.getContext('2d')
initCanvas(ctx)

const l1 = new Layer(2)
const l2 = new Layer(3, l1)
const l3 = new Layer(1, l2)
const layers = [l1, l2, l3]

const updateNetowrk = () => {
  l2.forward()
  l3.forward()
  drawNetwork(ctx, layers)
}

l1.setInputs([1, 1])
updateNetowrk()

initControls(layers, updateNetowrk)

window.setWeight = (li, ni, wi, v) => {
  try {
    layers[li].neurons[ni].weights[wi] = v
  } catch (e) {
    console.log(`Unable to set weight at ${li} -> ${ni} -> ${wi}: ${e}`)
  }
  updateNetowrk()
}

window.setBias = (li, ni, v) => {
  try {
    layers[li].neurons[ni].bias = v
  } catch (e) {
    console.log(`Unable to set bias at ${li} -> ${ni}: ${e}`)
  }
  updateNetowrk()
}

console.log(l1.neurons)
console.log(l2.neurons)