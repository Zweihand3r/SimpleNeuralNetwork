export const initControls = (layers, triggerRedraw) => {
  const ctrlRoot = createDiv(document.body, { className: 'ctrl-root' })
  for (let li = 1; li < layers.length; li++) {
    const layer = layers[li]
    const layerCon = createDiv(ctrlRoot, { className: 'layer-con' })

    for (let ni = 0; ni < layer.neurons.length; ni++) {
      const neuron = layer.neurons[ni]
      const neuronCon = createDiv(layerCon, { className: 'neuron-con' })

      for (let wi = 0; wi < neuron.weights.length; wi++) {
        createSlider(neuronCon, v => {
          neuron.weights[wi] = parseFloat(v)
          triggerRedraw()
        })
      }

      createSlider(neuronCon, v => {
        neuron.bias = parseFloat(v)
        triggerRedraw()
      }, { color: 'green', range: [-5, 5] })
    }
  }
}

const createDiv = (parent, { id, className, text }) => {
  if (parent) {
    const div = document.createElement('div')
    if (id) div.id = id
    if (className) div.className = className
    if (text) div.innerHTML = text
    parent.appendChild(div)
    return div
  } else {
    throw (`parent needs to be specified`)
  }
}

const createSlider = (parent, onChange, params) => {
  const { color = '', range = [-2, 2] } = params || { color: '', range: [-5, 5] }
  if (parent) {
    const slider = document.createElement('input')
    slider.type = 'range'
    slider.className = `slider slider-${color}`
    slider.value = 0
    slider.min = range[0]
    slider.max = range[1]
    slider.step = .00001
    slider.addEventListener('input', e => onChange(e.target.value))
    parent.appendChild(slider)
    return slider
  } else {
    throw (`parent needs to be specified`)
  }
}