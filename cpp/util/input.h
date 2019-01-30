#ifndef INPUT_H
#define INPUT_H

#include <QObject>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QMouseEvent>
#include <QDebug>
#include <QRect>

class Input : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool checkBounds READ checkBounds WRITE setCheckBounds)
    Q_PROPERTY(bool withinBounds READ withinBounds WRITE setWithinBounds NOTIFY withinBoundsChanged)

public:
    explicit Input(QObject *parent = nullptr);
    explicit Input(QApplication *app, QQmlApplicationEngine *engine);

    bool checkBounds();
    void setCheckBounds(const bool checkBounds);

    bool withinBounds();
    void setWithinBounds(const bool withinBounds);

    bool eventFilter(QObject *watched, QEvent *event);

private:
    QApplication *m_app;
    QQmlApplicationEngine *m_engine;
    QObject *m_target;

    bool m_checkBounds = false;
    bool m_withinBounds = false;

    int m_boundsXMin = 0;
    int m_boundsXMax = 0;
    int m_boundsYMin = 0;
    int m_boundsYMax = 0;

signals:
    void withinBoundsChanged();

public slots:
    void initializeTarget();

    void setBounds(const QRect rect);
    void setBounds(const int xMin, const int yMin, const int xMax, const int yMax);
};

#endif // INPUT_H
