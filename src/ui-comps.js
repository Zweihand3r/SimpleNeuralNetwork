export const createDiv = (parent, params) => {
  const { id, className, text } = params || {}
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

export const createSlider = (parent, onChange, params) => {
  const { 
    color = '', range = [-5, 5], step = .00001 
  } = params || { 
    color: '', range: [-5, 5], step: .00001 
  }
  if (parent) {
    const slider = document.createElement('input')
    slider.type = 'range'
    slider.className = `slider slider-${color}`
    slider.value = 0
    slider.min = range[0]
    slider.max = range[1]
    slider.step = step
    slider.addEventListener('input', e => onChange(e.target.value))
    parent.appendChild(slider)
    return slider
  } else {
    throw (`parent needs to be specified`)
  }
}

export const createDropdown = (parent, list, onChange, params) => {
  const { value, className } = params || {}
  if (parent) {
    const select = document.createElement('select')
    select.className = className || ''
    list.forEach(item => {
      const option = document.createElement('option')
      option.value = item
      option.innerHTML = item
      select.appendChild(option)
    })
    if (value) {
      select.value = value
    }
    select.addEventListener('change', e => onChange(e.target.value))
    parent.appendChild(select)
    return select
  } else {
    throw (`parent needs to be specified`)
  }
}

export const createButton = (parent, name, onClick, params) => {
  const { className } = params || {}
  if (parent) {
    const button = document.createElement('button')
    button.innerHTML = name
    button.className = `btn ${className || ''}`
    if (onClick) {
      button.addEventListener('click', onClick)
    }
    parent.appendChild(button)
    return button
  } else {
    throw (`parent needs to be specified`)
  }
}

export const createStepper = (parent, value = 1, params) => {
  const { 
    range = [1, 5], onChange = () => {} 
  } = params || { 
    range: [1, 5], onChange: () => {} 
  }
  const cont = createDiv(parent, { className: 'stepper-cont' })
  const incrBtn = createDiv(cont, { className: 'stepper-btn', text: '+' })
  const valueLbl = createDiv(cont, { className: 'stepper-lbl', text: value })
  const decrBtn = createDiv(cont, { className: 'stepper-btn', text: '-' })

  const setValue = v => {
    value = v
    valueLbl.innerHTML = v
  }

  const updateValue = v => {
    setValue(v)
    onChange(v)
  }

  incrBtn.addEventListener('click', () => updateValue(Math.min(value + 1, range[1])))
  decrBtn.addEventListener('click', () => updateValue(Math.max(value - 1, range[0])))

  return { 
    get value() { return value }, 
    set value(v) { setValue(v) }
  }
}

export const createVertSpacing = (parent, spacing) => {
  if (parent) {
    const div = createDiv(parent)
    div.style.height = `${spacing}px`
  }
}

export const createHorzSpacing = (parent, spacing) => {
  if (parent) {
    const div = createDiv(parent)
    div.style.width = `${spacing}px`
  }
}

export const spaces = (count) => Array(count).fill('&nbsp').join('')
