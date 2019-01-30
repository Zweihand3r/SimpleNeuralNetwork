#include "input.h"

Input::Input(QObject *parent) : QObject(parent)
{

}

Input::Input(QApplication *app, QQmlApplicationEngine *engine)
{
    app->installEventFilter(this);

    m_app = app;
    m_engine = engine;
}

bool Input::checkBounds()
{
    return m_checkBounds;
}

void Input::setCheckBounds(const bool checkBounds)
{
    if (m_checkBounds != checkBounds) {
        m_checkBounds = checkBounds;

        if (!m_checkBounds && m_withinBounds)
            setWithinBounds(false);
    }
}

bool Input::withinBounds()
{
    return m_withinBounds;
}

void Input::setWithinBounds(const bool withinBounds)
{
    if (m_withinBounds != withinBounds) {
        m_withinBounds = withinBounds;
        emit withinBoundsChanged();
    }
}

bool Input::eventFilter(QObject *watched, QEvent *event)
{
    if (m_checkBounds) {
        if (m_target == watched) {
            QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event);

            QPointF position = mouseEvent->windowPos();
            bool withinBounds = true;

            if (position.x() > 0.01 && position.y() > 0.01) {
                if (position.x() < m_boundsXMin) { withinBounds = false; }
                else if (position.x() > m_boundsXMax) { withinBounds = false; }
                else if (position.y() < m_boundsYMin) { withinBounds = false; }
                else if (position.y() > m_boundsYMax) { withinBounds = false; }

                if (event->type() == QEvent::MouseButtonPress) {
                    qDebug() << "input.cpp: mouse at:" << position << "within bounds?" << withinBounds;
                }
            }

            setWithinBounds(withinBounds);

            if (!m_withinBounds) setCheckBounds(false);
        }
    }

    return QObject::eventFilter(watched, event);
}

void Input::initializeTarget()
{
    m_target = m_engine->rootObjects()[0];
}

void Input::setBounds(const QRect rect)
{
    setBounds(rect.x(), rect.y(), rect.x() + rect.width(), rect.y() + rect.height());
}

void Input::setBounds(const int xMin, const int yMin, const int xMax, const int yMax)
{
    m_boundsXMin = xMin;
    m_boundsYMin = yMin;
    m_boundsXMax = xMax;
    m_boundsYMax = yMax;

    qDebug() << "input.cpp: bounds set to" << m_boundsXMin << m_boundsYMin << m_boundsXMax << m_boundsYMax;
}
