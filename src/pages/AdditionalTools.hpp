#pragma once

#include <QtWidgets/QWizardPage>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QTimer>
#include "packages/Package.hpp"
#include "utilities.hpp"
#include "packages/MinGW.hpp"


namespace pages
{

    class AdditionalTools : public QWizardPage {
        // Q_OBJECT

    private:

        curlpp::Multi _http;
        QTimer *_timer;
        QComboBox *_picker;
        QLabel *_loading;
    public:
    packages::MinGW package;
        explicit AdditionalTools(QWidget *parent = nullptr);
        ~AdditionalTools() override = default;

        void initializePage() override;
    };

}
