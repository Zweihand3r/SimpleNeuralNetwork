const presets = {
  xor_231_rs: [[{w:[],b:0},{w:[],b:0}],[{w:[-1.86405,1.83384],b:-0.08761},{w:[0,0],b:0},{w:[1.82175,-1.9003],b:-0.03927}],[{w:[3.43505,0,3.41088],b:-2.89728}]],
  xor_221_rs: [[{w:[],b:0},{w:[],b:0}],[{w:[-1.86405,1.83384],b:-0.08761},{w:[1.82175,-1.9003],b:-0.03927}],[{w:[3.43505,3.41088],b:-2.89728}]]
}

export const parsePreset = key => {
  const [_, layerStr, activationStr] = key.split('_')
  const layers = layerStr.split('').map(litem => parseInt(litem))
  const activations = activationStr.split('').map(
    aitem => {
      switch (aitem) {
        case 'r': return 'relu'
        case 's': return 'sigmoid'
        default: return ''
      }
    }
  )
  return { layers, activations }
}

export default presets