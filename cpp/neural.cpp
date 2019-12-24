#include "neural.h"

Neural::Neural(QObject *parent) : QObject(parent)
{

}

QVector<QVector<float> > Neural::train(QVector<QVector<float> > inputs, QVector<QVector<float> > outputs, const int trainSteps)
{
    QVector<QVector<float>> l1;
    QVector<QVector<float>> l2;
    QVector<QVector<float>> l1_error;
    QVector<QVector<float>> l2_error;
    QVector<QVector<float>> l1_delta;
    QVector<QVector<float>> l2_delta;

    for (int index = 0; index < trainSteps; index++) {
        l1 = sigmoid(Matrix::dot(inputs, syn0));
        l2 = sigmoid(Matrix::dot(l1, syn1));

        l2_error = Matrix::subtract(outputs, l2);
        l2_delta = Matrix::multiply(l2_error, sigmoidDerivative(l2));

        l1_error = Matrix::dot(l2_delta, Matrix::transpose(syn1));
        l1_delta = Matrix::multiply(l1_error, sigmoidDerivative(l1));

        syn1 = Matrix::add(syn1, Matrix::dot(Matrix::transpose(l1), l2_delta));
        syn0 = Matrix::add(syn0, Matrix::dot(Matrix::transpose(inputs), l1_delta));
    }

    return l2;
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

QVector<QVector<float> > Neural::toVector(const QStringList stringList)
{
    QVector<QVector<float>> vector;
    for (QString rowStr : stringList) {
        QStringList rowElements = rowStr.split(" ");
        QVector<float> row;

        for (QString element : rowElements) {
            row.push_back(element.toFloat());
        }

        vector.push_back(row);
    }

    return vector;
}

QStringList Neural::toStringList(const QVector<QVector<float> > vector)
{
    QStringList stringList;
    for (QVector<float> row : vector) {
        QString rowStr = "";

        for (int index = 0; index < row.length(); index++) {
            if (index > 0) rowStr += " ";
            rowStr += QString::number(row[index]);
        }

        stringList << rowStr;
    }

    return stringList;
}

void Neural::initializeNetwork(const int inputCount, const int outputCount, const int nodeCount)
{
    if (m_inputCount != inputCount) m_inputCount = inputCount;
    if (m_outputCount != outputCount) m_outputCount = outputCount;
    if (m_nodeCount != nodeCount) m_nodeCount = nodeCount;

    syn0 = randomisedWeights(inputCount, nodeCount);
    syn1 = randomisedWeights(nodeCount, outputCount);

//    qDebug() << "neural.cpp: syn0:" << syn0;
//    qDebug() << "neural.cpp: syn1:" << syn1;
}

void Neural::resetNetwork()
{
    initializeNetwork(m_inputCount, m_outputCount, m_nodeCount);
}

QStringList Neural::train(QStringList inputs, QStringList outputs, const int trainSteps)
{
    QVector<QVector<float>> res = train(toVector(inputs), toVector(outputs), trainSteps);
    return toStringList(res);
}

QStringList Neural::compute(QStringList inputs)
{
    QVector<QVector<float>> l1 = sigmoid(Matrix::dot(toVector(inputs), syn0));
    QVector<QVector<float>> l2 = sigmoid(Matrix::dot(l1, syn1));
    return toStringList(l2);
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
