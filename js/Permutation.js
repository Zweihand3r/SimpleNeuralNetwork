function string(str) {
    return array(str.split(""))
}

function array(arr) {
    var res = []
    var tallyMap = {}

    if (arr.length <= 2) {
        return permute_x2(arr)
    }

    for (var index = 0; index < arr.length; index++) {
        var arr_ = arr.slice()
        if (index > 0) arr_.move(index, 0)

        if (!tallyMap[arr_[0]]) tallyMap[arr_[0]] = 1
        else continue

        var str_x = arr_.slice(1, arr_.length)
        var res_x = array(str_x)

        res_x.forEach(function(element){
            var res_ = [arr_[0]]
            for (var x = 1; x < arr.length; x++)
                res_.push(element[x - 1])
            res.push(res_)
        })
    }

    return res
}

function variant(mat) {
    var res = []

    if (mat.length <= 2) {
        return permuteVariant_x2(mat)
    }

    var arr = mat[0]
    var arr_ = []
    for (var index = 1; index < mat.length; index++)
        arr_.push(mat[index])

    var res_x = variant(arr_)

    for (var index_ = 0; index_ < arr.length; index_++) {
        res_x.forEach(function(element) {
            var res_ = [arr[index_]]
            for (var x = 1; x < mat.length; x++) {
                res_.push(element[x - 1])
            }
            res.push(res_)
        })
    }

    return res
}

function value(int) {
    var res = 1
    for (var index = int; index > 0; index--) {
        res *= index
    }
    return res
}

/* --------------------------------------------------- */

function permute_x2(arr) {
    var res = []
    res.push([arr[0], arr[1]])
    if (arr[0] !== arr[1])
        res.push([arr[1], arr[0]])

    return res
}

function permuteVariant_x2(arr) {
    var res = []
    var arr_ = arr[0]
    var arr_1 = arr[1]

    for (var index_ = 0; index_ < arr_.length; index_++) {
        for (var index_1 = 0; index_1 < arr_1.length; index_1++) {
            res.push([arr_[index_], arr_1[index_1]])
        }
    }

    return res
}

/* --------------------------------------------------- */

function moveArrayElement(array, from, to) {
    array.move(from, to)
}

Array.prototype.move = function(from, to) {
    this.splice(to, 0, this.splice(from, 1)[0])
}
