function multiply(mat_a, mat_b) {
    var transposed = false

    if (typeof(mat_a[0]) === "number")
        mat_a = [mat_a]

    if (mat_a[0].length !== mat_b.length) {
        console.log("The columns of the first matrix must be equal to the rows of the second matrix")
        return []
    }

    if (typeof(mat_b[0]) === "number") {
        mat_b = transpose([mat_b])
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

    if (transposed) res = transpose(res)

    return res
}

function transpose(mat) {
    var transposed = []
    for (var index = 0; index < mat[0].length; index++) {
        transposed.push([])
    }

    mat.forEach(function(row, rowIndex) {
        row.forEach(function(element, index) {
            console.log(rowIndex + "-" + index + ": " + element)
            transposed[index][rowIndex] = element
        })
    })

    return transposed
}

function multiply_test() {
    var transposed = false

    var mat_b = [1,2,3]
    var mat_a = [
                [1,2,3],
                [4,5,6],
                [7,8,9]
            ]

    if (typeof(mat_a[0]) === "number")
        mat_a = [mat_a]

    var mat_a_colLength = mat_a[0].length
    var mat_b_rowLength = mat_b.length

    if (typeof(mat_b[0]) === "number") {
        mat_b = transpose([mat_b])
        transposed = true
    }

    if (mat_a_colLength !== mat_b_rowLength) {
        console.log("The columns of the first matrix must be equal to the rows of the second matrix")
        return
    }

    var mat_a_rowLength = mat_a.length
    var mat_b_colLength = mat_b[0].length

//    mat_a.forEach(function(row_a, index_a) {
//        var res_row = []
//        row_a.forEach(function(element, index) {
//            console.log(index_a + ": " + element + ", " + mat_b[index][index_a])
//        })
//    })

    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        for (var index_colB = 0; index_colB < mat_b_colLength; index_colB++) {
            var summation = 0
            rowA.forEach(function(element, index) {
                console.log(mat_b[index])
                console.log(index_colB + ": " + element + ", " + mat_b[index][index_colB])
                summation += (element * mat_b[index][index_colB])
            })
            res_row.push(summation)
        }
        res.push(res_row)
    })

    if (transposed) res = transpose(res)

    res.forEach(function(res_e) {
        console.log(res_e)
    })
}

function transposeTest() {
    var mat = [
                [1, 2, 3]
            ]

    var col_length = mat[0].length
    var transposed = []
    for (var index = 0; index < col_length; index++) {
        transposed.push([])
    }

    mat.forEach(function(row, rowIndex) {
        row.forEach(function(element, index) {
            console.log(rowIndex + "-" + index + ": " + element)
            transposed[index][rowIndex] = element
        })
    })

    transposed.forEach(function(index_e) {
        console.log(index_e)
    })
}
