#pragma once

#include <QtWidgets/QWizardPage>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QTimer>

#include "utilities.hpp"

namespace pages
{

    class AdditionalTools : public QWizardPage {
        // Q_OBJECT

    private:


    public:
        explicit AdditionalTools(QWidget *parent = nullptr);
        ~AdditionalTools() override = default;

        void initializePage() override;
    };

}
