// powerbutton.hpp
#ifndef POWERMENU_HPP
#define POWERMENU_HPP

#include <QObject>

class PowerMenu : public QObject {
    Q_OBJECT
public:
    explicit PowerMenu(QObject* parent = nullptr);
    virtual ~PowerMenu() = default;

    Q_INVOKABLE void shutdown();
    Q_INVOKABLE void restart();
    Q_INVOKABLE void switchToDesktop();
};

#endif // POWERMENU_HPP
