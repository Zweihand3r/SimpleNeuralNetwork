/*
  * translated from python to js from:
  * https://medium.com/technology-invention-and-more/how-to-build-a-simple-neural-network-in-9-lines-of-python-code-cc8f23647ca1
  */

var weights = []

function train_test() {
    var inputs = [[0,0,1], [1,1,1], [1,0,1], [0,1,1]]
    var outputs = [[0],[1],[1],[0]] // [array]
    var weights = [] // array
//    for (var index = 0; index < inputs[0].length; index++)
//        weights.push((Math.random() * 2) - 1)
//    console.log("Weights initialised to: " + weights)

    weights = [-0.2, 0.1, 0.3]

    for (var index = 0; index < 10000; index++) {
        // [array]
        var mat_mul = multiply_matrix(inputs, weights)
//        console.log("Inputs x Weights: " + mat_mul)

//        // array
        var output = sigmoid_array(mat_mul)
//        console.log("Output > Sigmoid result: " + output)

//        // array
        var output_difference = subtract_arrays(transpose_matrix(outputs)[0], output)
//        console.log("Error > output_difference: " + output_difference)

        // array
        var errXoutput = multiply_arrays(output_difference, output)
//        console.log("Error x output: " + errXoutput)

        // array
        var sig_deriv = subtract_num_array(1, output)
//        console.log("Derivative: " + sig_deriv)

        // array
        var erropXsigdrv = multiply_arrays(errXoutput, sig_deriv)
//        console.log("(Error x output) x Derivative: " + erropXsigdrv)

        // [array]
        var adjustment = multiply_matrix(transpose_matrix(inputs), erropXsigdrv)
//        console.log("Adjustment: " + adjustment)

        // array
        weights = add_arrays(weights, adjustment[0])
//        console.log("Weights after adjustment: " + weights)
    }

    console.log("Weights after training: " + weights)

    var test_mat_mul = multiply_matrix([1, 0, 0], weights)
    console.log(1 / (1 + Math.exp(-test_mat_mul)))
}

function sigmoid_array(arr) {
    var res = []
    arr[0].forEach(function(element) {
        res.push(1 / (1 + Math.exp(-element)))
    })
    return res
}

function multiply_matrix(mat_a, mat_b) {
    var transposed = false
    if (typeof(mat_a[0]) === "number") mat_a = [mat_a]
    if (mat_a[0].length !== mat_b.length) {
        console.log("The columns of the first matrix must be equal to the rows of the second matrix")
        return []
    }
    if (typeof(mat_b[0]) === "number") {
        mat_b = transpose_matrix([mat_b])
        transposed = true
    }
    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        for (var index_colB = 0; index_colB < mat_b[0].length; index_colB++) {
            var summation = 0
            rowA.forEach(function(element, index) {
//                console.log(/*index_colB + ": " + */element + ", " + mat_b[index][index_colB])
                summation += (element * mat_b[index][index_colB])
            })
            res_row.push(summation)
        }
        res.push(res_row)
    })
    if (transposed) res = transpose_matrix(res)
    return res
}

function multiply_arrays(arr_1, arr_2) {
    if (arr_1.length !== arr_2.length) {
        console.log("Cant multiply arrays > Different sizes")
        return
    }

    var res = []
    arr_1.forEach(function(element, index) {
        res.push(element * arr_2[index])
    })
    return res
}

function add_arrays(arr_1, arr_2) {
    if (arr_1.length !== arr_2.length) {
        console.log("Cant add arrays > Different sizes")
        return
    }

    var res = []
    arr_1.forEach(function(element, index) {
        res.push(element + arr_2[index])
    })
    return res
}

function subtract_arrays(arr_1, arr_2) {
    if (arr_1.length !== arr_2.length) {
        console.log("Cant substract arrays > Different sizes")
        return
    }

    var res = []
    arr_1.forEach(function(element, index) {
        res.push(element - arr_2[index])
    })
    return res
}

function subtract_num_array(num, arr) {
    var res = []
    arr.forEach(function(element) {
        res.push(num - element)
    })
    return res
}

function transpose_matrix(mat) {
    var transposed = []
    for (var index = 0; index < mat[0].length; index++) {
        transposed.push([])
    }

    mat.forEach(function(row, rowIndex) {
        row.forEach(function(element, index) {
//            console.log(rowIndex + "-" + index + ": " + element)
            transposed[index][rowIndex] = element
        })
    })

    return transposed
}
