#pragma once

#include <QtWidgets/QWizardPage>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QTimer>

#include "utilities.hpp"
#include "packages/Lua.hpp"

namespace pages
{
    class Lua : public QWizardPage {
        // Q_OBJECT

    private:
        curlpp::Multi _http;
        QTimer *_timer;
        QComboBox *_picker;
        QLabel *_loading;

    public:
        packages::Lua package;

        explicit Lua(QWidget *parent = nullptr);
        ~Lua() override = default;

        void initializePage() override;

        Version selected_version() const;

    private:
        void check_future();
    };
}
