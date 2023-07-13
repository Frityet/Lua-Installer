#pragma once

#include <QtWidgets/QWizardPage>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QTimer>

#include "utilities.hpp"
#include "packages/Luarocks.hpp"

namespace pages
{
    class Luarocks : public QWizardPage {
        // Q_OBJECT

    private:
        curlpp::Multi _http;
        QTimer *_timer;
        QComboBox *_picker;
        QLabel *_loading;

    public:
        packages::Luarocks package;

        explicit Luarocks(QWidget *parent = nullptr);
        ~Luarocks() override = default;

        void initializePage() override;

    private:
        void check_future();
    };
}
