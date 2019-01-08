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

    return res;
}
