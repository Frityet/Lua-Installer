#pragma once

#include "Qt.hpp"

#include "utilities.hpp"

namespace pages
{
    class Progress : public QWizardPage {
        // Q_OBJECT

    public:
        QLabel *Status;
        QProgressBar *Progressbar;
        explicit Progress(QWidget *parent = nullptr);
        void SetProgress();
        ~Progress() override = default;

        void initializePage() override;

};
}