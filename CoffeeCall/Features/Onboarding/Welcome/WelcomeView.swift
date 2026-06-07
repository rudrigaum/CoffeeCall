import UIKit

final class WelcomeView: UIView {

    // MARK: - UI Actions
    var onNextButtonTapped: (() -> Void)?
    var onPageControlTapped: ((Int) -> Void)?

    // MARK: - UI Elements
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "onboarding_coffee") {
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 180, weight: .light)
            imageView.image = UIImage(systemName: "cup.and.saucer.fill", withConfiguration: config)
            imageView.tintColor = .white
            imageView.contentMode = .scaleAspectFit
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        if let descriptor = UIFont.systemFont(ofSize: 36, weight: .bold).fontDescriptor.withDesign(.rounded) {
            label.font = UIFont(descriptor: descriptor, size: 36)
        } else {
            label.font = .systemFont(ofSize: 36, weight: .bold)
        }
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 3
        pc.currentPageIndicatorTintColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        pc.pageIndicatorTintColor = .systemGray5
        pc.isUserInteractionEnabled = true
        pc.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)

        if #available(iOS 14.0, *) {
            pc.backgroundStyle = .minimal
        }
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let arrowImage = UIImage(systemName: "arrow.right", withConfiguration: config)

        button.setImage(arrowImage, for: .normal)
        button.backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        button.tintColor = .white

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.2

        button.layer.cornerRadius = 30
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func updateDisplay(title: String, subtitle: String, currentPage: Int, animated: Bool = true) {
        let updates = {
            self.titleLabel.text = title
            self.subtitleLabel.attributedText = self.formatSubtitle(subtitle)
            self.pageControl.currentPage = currentPage
        }

        if animated {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: updates, completion: nil)
        } else {
            updates()
        }
    }

    // MARK: - Helpers

    private func formatSubtitle(_ text: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let fullRange = NSRange(location: 0, length: text.count)

        attributedString.addAttributes([
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: UIColor.secondaryLabel
        ], range: fullRange)

        let components = text.components(separatedBy: "\n")
        if let firstLine = components.first, !firstLine.isEmpty {
            let range = (text as NSString).range(of: firstLine)

            attributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 24, weight: .semibold),
                .foregroundColor: UIColor.label
            ], range: range)
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

        return attributedString
    }

    // MARK: - Actions

    @objc private func didTapButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.nextButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.nextButton.transform = .identity
            }
            self.onNextButtonTapped?()
        }
    }

    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        onPageControlTapped?(sender.currentPage)
    }

    // MARK: - View Code Setup
    private func setupView() {
        backgroundColor = .systemBackground

        addSubview(topContainerView)
        topContainerView.addSubview(logoImageView)
        topContainerView.addSubview(titleLabel)

        addSubview(subtitleLabel)
        addSubview(pageControl)
        addSubview(nextButton)

        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: topAnchor),
            topContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.60),

            logoImageView.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor, constant: -20),
            logoImageView.widthAnchor.constraint(equalToConstant: 320),
            logoImageView.heightAnchor.constraint(equalToConstant: 320),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 32),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),

            pageControl.centerYAnchor.constraint(equalTo: nextButton.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),

            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
