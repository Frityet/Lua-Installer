#pragma once

#include <QtWidgets/QWizardPage>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QLabel>
#include <QtWidgets/QCheckBox>
#include <QTimer>
#include "packages/Package.hpp"
#include "utilities.hpp"
#include "packages/MinGW.hpp"


namespace pages
{

    class AdditionalTools : public QWizardPage {
        // Q_OBJECT

    private:
        QCheckBox *_make_checkbox;
        QCheckBox *_mingw_checkbox;
        QCheckBox *_llvm_checkbox;
    public:
    packages::MinGW package;
        explicit AdditionalTools(bool *make, bool *mingw, bool *llvm, QWidget *parent = nullptr);
        ~AdditionalTools() override = default;

        void initializePage() override;
            private:
        void check_future();
    };

}
