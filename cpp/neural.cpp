#include "neural.h"

Neural::Neural(QObject *parent) : QObject(parent)
{

}

QVector<QVector<float> > Neural::sigmoid(QVector<QVector<float> > mat)
{
    QVector<QVector<float>> res(mat.length());

    for (int rowIndex = 0; rowIndex < mat.length(); rowIndex++) {
        QVector<float> row = mat[rowIndex];
        QVector<float> res_row(row.length());

        for (int index = 0; index < row.length(); index++) {
            res_row[index] = 1 / (1 + qExp(-row[index]));
        }

        res[rowIndex] = res_row;
    }

    return res;
}

QVector<QVector<float> > Neural::sigmoidDerivative(QVector<QVector<float> > mat)
{
    QVector<QVector<float>> res(mat.length());

    for (int rowIndex = 0; rowIndex < mat.length(); rowIndex++) {
        QVector<float> row = mat[rowIndex];
        QVector<float> res_row(row.length());

        for (int index = 0; index < row.length(); index++) {
            res_row[index] = 1 - row[index];
        }

        res[rowIndex] = res_row;
    }

    return Matrix::multiply(mat, res);
}

QVector<QVector<float> > Neural::randomisedWeights(const int rows, const int cols)
{
    QVector<QVector<float>> res(rows);

    for (int index = 0; index < rows; index++) {
        QVector<float> res_row(cols);

        for (int index_ = 0; index_ < cols; index_++) {
            res_row[index_] = (rand() % 200) / 100.0 - 1.0;
        }

        res[index] = res_row;
    }

    return res;
}

QVector<QVector<float> > Neural::getSigmoid(QVector<QVector<float> > mat)
{
    return sigmoid(mat);
}

QVector<QVector<float> > Neural::getSigmoidDerivative(QVector<QVector<float> > mat)
{
    return sigmoidDerivative(mat);
}

QVector<QVector<float> > Neural::getRandomisedWeights(const int rows, const int cols)
{
    return randomisedWeights(rows, cols);
}
