function dot(mat_a, mat_b) {
    /*
     * 1D matrix must be [array] not array
     * Need columns of first matrix to be equal to the rows of second matrix
     * Use transpose if there is only one row (array) in the second matrix
     */

    if (mat_a[0].length !== mat_b.length) {
        console.log("The columns of the first matrix must be equal to the rows of the second matrix")
        return []
    }

    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        for (var index_colB = 0; index_colB < mat_b[0].length; index_colB++) {
            var summation = 0
            rowA.forEach(function(element, index) {
                summation += (element * mat_b[index][index_colB])
            })
            res_row.push(summation)
        }
        res.push(res_row)
    })

    return res
}

function add(mat_a, mat_b) {
    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        rowA.forEach(function(element, index) {
            res_row.push(element + mat_b[index_rowA][index])
        })
        res.push(res_row)
    })

    return res
}

function subtract(mat_a, mat_b) {
    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        rowA.forEach(function(element, index) {
            res_row.push(element - mat_b[index_rowA][index])
        })
        res.push(res_row)
    })

    return res
}

function multiply(mat_a, mat_b) {
    var res = []
    mat_a.forEach(function(rowA, index_rowA) {
        var res_row = []
        rowA.forEach(function(element, index) {
            res_row.push(element * mat_b[index_rowA][index])
        })
        res.push(res_row)
    })

    return res
}

function transpose(mat) {
    var transposed = []
    for (var index = 0; index < mat[0].length; index++)
        transposed.push([])

    mat.forEach(function(row, rowIndex) {
        row.forEach(function(element, index) {
            transposed[index][rowIndex] = element
        })
    })

    return transposed
}

function fillCheck(mat) {
    /*
     * Checkes whether a matrix is filled to a square/rectangle shape
     * [[1, 2], [3, 4]] is filled (square)
     * [[1, 2], [3, 4], [5, 6]] is filled (rectangle)
     * [[1, 2], [3, 4, 5]] is not filled
     */
    var comareCount = mat[0].length
    if (mat.length > 0) {
        for (var index = 1; index < mat.length; index++)
            if (mat[index].length !== comareCount) return false
    }
    return true
}

function sizeCheck(mat_a, mat_b) {
    if (mat_a.length !== mat_b.length) return false
    if (mat_a[0].length !== mat_b[0].length) return false
    return true
}
