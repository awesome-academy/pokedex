//
//  DetailsViewController.swift
//  PokedexApp
//
//  Created by Phong Le on 24/06/2021.
//

import UIKit

class DetailsViewController: UIViewController {
    private var pokemon: Pokemon?
    private let spinner = UIActivityIndicatorView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.isHidden = true
        return stackView
    }()
    
    private let imagePokemon: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.clipsToBounds = true
        uiImageView.contentMode = .scaleAspectFit
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureSpinner()
        configureScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        spinner.frame = view.bounds
        scrollView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureImagePokemon { [weak self] (image) in
            guard let self = self else { return }
            
            if let image = image {
                DispatchQueue.main.async {
                    self.imagePokemon.image = image
                    self.resetInfomationDetail()
                }
            } else {
                self.resetInfomationDetail()
            }
        }
    }
    
    private func resetInfomationDetail() {
        configureConstraintContentView()
        configureConstraintStackView()
        spinner.stopAnimating()
        stackView.isHidden = false
    }
    
    private func configure() {
        guard
            let pokemon = pokemon,
            let id = pokemon.id,
            let types = pokemon.types,
            let pokemonType = types.first
        else { return }
        
        guard
            let forms = pokemon.forms,
            let obj = forms.first
        else { return }
        
        guard let nav = navigationController else { return }

        view.backgroundColor = App.Color.backgroundColor
        navigationItem.title = obj.name.capitalizingFirstLetter()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "#\(id)",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSavePokemon))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left",
                                                                          withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapDismiss))
        nav.navigationBar.shadowImage = UIImage() // delete shadow navigation bar
        nav.navigationBar.tintColor = App.Color.fontText
        nav.navigationBar.barTintColor = pokemonType.type.name.backgroundColor
    }

    private func configureSpinner() {
        view.addSubview(spinner)
        spinner.color = .white
        spinner.startAnimating()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: 0,
                                               left: 0,
                                               bottom: 25,
                                               right: 0)
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    private func configureConstraintContentView() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ])
    }
    private func configureConstraintStackView() {
        guard
            let pokemon = pokemon,
            let types = pokemon.types,
            let weight = pokemon.weight,
            let height = pokemon.height,
            let abilities = pokemon.abilities,
            let stats = pokemon.stats,
            let pokemonType = types.first
        else { return }
            
        //container Image
        let containerImage = UIView()
        containerImage.backgroundColor = pokemonType.type.name.backgroundColor
        containerImage.translatesAutoresizingMaskIntoConstraints = false
        containerImage.layer.masksToBounds = true
        containerImage.layer.cornerRadius = 40
        containerImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        let stackViewTypesRoot = UIStackView()
        stackViewTypesRoot.axis = .horizontal
        stackViewTypesRoot.translatesAutoresizingMaskIntoConstraints = false
        stackViewTypesRoot.alignment = .top
        
        let textInfo = UILabel()
        textInfo.text = "Info"
        textInfo.font = App.Font.pixel18
        textInfo.textColor = App.Color.fontText
        textInfo.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewWeightRoot = UIStackView()
        stackViewWeightRoot.axis = .horizontal
        stackViewWeightRoot.alignment = .top
        stackViewWeightRoot.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewHeightRoot = UIStackView()
        stackViewHeightRoot.axis = .horizontal
        stackViewHeightRoot.translatesAutoresizingMaskIntoConstraints = false
        stackViewHeightRoot.alignment = .top
        
        let stackViewAbilitiesRoot = UIStackView()
        stackViewAbilitiesRoot.axis = .horizontal
        stackViewAbilitiesRoot.translatesAutoresizingMaskIntoConstraints = false
        stackViewAbilitiesRoot.alignment = .top
        
        let textBaseStats = UILabel()
        textBaseStats.font = App.Font.pixel16
        textBaseStats.text = "Base Stats"
        textBaseStats.textColor = App.Color.fontText
        textBaseStats.translatesAutoresizingMaskIntoConstraints = false
        
        let stackViewRootStats = UIStackView()
        stackViewRootStats.axis = .vertical
        stackViewRootStats.spacing = 25
        stackViewRootStats.translatesAutoresizingMaskIntoConstraints = false
        stackViewRootStats.alignment = .top
        
        stackView.addArrangedSubview(containerImage)
        stackView.addArrangedSubview(textInfo)
        stackView.addArrangedSubview(stackViewTypesRoot)
        stackView.addArrangedSubview(stackViewWeightRoot)
        stackView.addArrangedSubview(stackViewHeightRoot)
        stackView.addArrangedSubview(stackViewAbilitiesRoot)
        stackView.addArrangedSubview(textBaseStats)
        stackView.addArrangedSubview(stackViewRootStats)
        
        NSLayoutConstraint.activate([
            containerImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor,
                                                   multiplier:  (238 / scrollView.bounds.height)),
            containerImage.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        containerImage.addSubview(imagePokemon)
        NSLayoutConstraint.activate([
            imagePokemon.centerXAnchor.constraint(equalTo: containerImage.centerXAnchor),
            imagePokemon.centerYAnchor.constraint(equalTo: containerImage.centerYAnchor),
            imagePokemon.heightAnchor.constraint(equalTo: containerImage.heightAnchor,
                                                 multiplier: (250 / (238 / scrollView.bounds.height))),
            imagePokemon.widthAnchor.constraint(equalTo: containerImage.widthAnchor,
                                                multiplier: (250 / view.bounds.width))
        ])
        
        guard var tempView = stackView.subviews.first else { return }
        stackView.subviews.enumerated().forEach { (index, view) in
            if index != 0 {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: tempView.safeAreaLayoutGuide.bottomAnchor, constant: 28),
                    view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 39),
                    view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                ])
                tempView = view
            }
        }
        
        // type
        let titleType = UILabel()
        titleType.text = "Type"
        titleType.font = App.Font.pixel14
        titleType.textColor = App.Color.fontTextTitle
        
        let stackViewListType = UIStackView()
        stackViewListType.axis = .vertical
        stackViewListType.spacing = 15
        stackViewListType.translatesAutoresizingMaskIntoConstraints = false
        
        types.enumerated().forEach { (index, pokemonType) in
            if index < 2 || (types.count < 2 && index == 1) {
                let type = UILabel()
                type.font = App.Font.pixel14
                let name = pokemonType.type.name.rawValue.capitalizingFirstLetter()
                type.text = (index == 1 && types.count > 2) ? name + "..." : name
                type.textColor = App.Color.fontText
                type.translatesAutoresizingMaskIntoConstraints = false
                stackViewListType.addArrangedSubview(type)
            }
        }
        
        stackViewTypesRoot.addArrangedSubview(titleType)
        stackViewTypesRoot.addArrangedSubview(stackViewListType)
        
        NSLayoutConstraint.activate([
            titleType.widthAnchor.constraint(equalTo: stackViewTypesRoot.widthAnchor, multiplier: 0.4)
        ])
        
        // weight
        let titleWeight = UILabel()
        titleWeight.text = "Weight"
        titleWeight.font = App.Font.pixel14
        titleWeight.textColor = App.Color.fontTextTitle
        titleWeight.translatesAutoresizingMaskIntoConstraints = false

        let titleWeightResult = UILabel()
        titleWeightResult.font = App.Font.pixel14
        titleWeightResult.text = weight.addDotLastNumber() + " kg"
        titleWeightResult.textColor = App.Color.fontText
        titleWeightResult.translatesAutoresizingMaskIntoConstraints = false

        stackViewWeightRoot.addArrangedSubview(titleWeight)
        stackViewWeightRoot.addArrangedSubview(titleWeightResult)

        NSLayoutConstraint.activate([
            titleWeight.widthAnchor.constraint(equalTo: stackViewWeightRoot.widthAnchor, multiplier: 0.4)
        ])

        // height
        let titleHeight = UILabel()
        titleHeight.font = App.Font.pixel14
        titleHeight.text = "Height"
        titleHeight.textColor = App.Color.fontTextTitle
        titleHeight.translatesAutoresizingMaskIntoConstraints = false

        let titleHeightResult = UILabel()
        titleHeightResult.font = App.Font.pixel14
        titleHeightResult.text = height.addDotLastNumber() + " m"
        titleHeightResult.textColor = App.Color.fontText
        titleHeightResult.translatesAutoresizingMaskIntoConstraints = false

        stackViewHeightRoot.addArrangedSubview(titleHeight)
        stackViewHeightRoot.addArrangedSubview(titleHeightResult)

        NSLayoutConstraint.activate([
            titleHeight.widthAnchor.constraint(equalTo: stackViewHeightRoot.widthAnchor, multiplier: 0.4)
        ])

        // abilities
        let titleAbilities = UILabel()
        titleAbilities.font = App.Font.pixel14
        titleAbilities.text = "Abilities"
        titleAbilities.textColor = App.Color.fontTextTitle
        titleAbilities.translatesAutoresizingMaskIntoConstraints = false

        let stackViewListAbilities = UIStackView()
        stackViewListAbilities.axis = .vertical
        stackViewListAbilities.spacing = 15
        stackViewListAbilities.translatesAutoresizingMaskIntoConstraints = false

        abilities.enumerated().forEach { (index, pokemonAbilities) in
            if index < 2 || (abilities.count < 2 && index == 1) {
                let ability = UILabel()
                ability.font = App.Font.pixel14
                let name = pokemonAbilities.ability.name.capitalizingFirstLetter()
                ability.text = (index == 1 && abilities.count > 2) ? name + "..." : name
                ability.textColor = App.Color.fontText
                ability.translatesAutoresizingMaskIntoConstraints = false
                stackViewListAbilities.addArrangedSubview(ability)
            }
        }

        stackViewAbilitiesRoot.addArrangedSubview(titleAbilities)
        stackViewAbilitiesRoot.addArrangedSubview(stackViewListAbilities)

        NSLayoutConstraint.activate([
            titleAbilities.widthAnchor.constraint(equalTo: stackViewAbilitiesRoot.widthAnchor, multiplier: 0.4)
        ])

        // stats
        stats.enumerated().forEach { (index, stat) in
            if index != 3 && index != 4 {
                let stackViewStat = UIStackView()
                stackViewStat.axis = .horizontal
                stackViewStat.translatesAutoresizingMaskIntoConstraints = false
                stackViewStat.alignment = .top

                stackViewRootStats.addArrangedSubview(stackViewStat)

                let dataStat = UILabel()
                dataStat.font = App.Font.pixel14
                dataStat.text = stat.statName.name.uppercased()
                dataStat.textColor = App.Color.fontTextTitle
                dataStat.translatesAutoresizingMaskIntoConstraints = false

                let uiViewStat = UIView()
                uiViewStat.layer.masksToBounds = true
                uiViewStat.layer.cornerRadius = 8
                uiViewStat.backgroundColor = App.Color.backgroundColorStat
                uiViewStat.translatesAutoresizingMaskIntoConstraints = false

                let data = UILabel()
                let dataText = String(describing: stat.baseStat)
                data.font = App.Font.pixel12
                data.text = stat.baseStat <= 100 ? "\(dataText)/100" : "100/100"
                data.textColor = App.Color.fontText
                data.backgroundColor = BaseStats(rawValue: stat.statName.name)?.baseStatColor
                data.layer.masksToBounds = true
                data.layer.cornerRadius = 8
                data.translatesAutoresizingMaskIntoConstraints = false
                data.textAlignment = .right

                stackViewStat.addArrangedSubview(dataStat)
                stackViewStat.addArrangedSubview(uiViewStat)

                NSLayoutConstraint.activate([
                    uiViewStat.topAnchor.constraint(equalTo: stackViewStat.topAnchor),
                    uiViewStat.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -15),
                    uiViewStat.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 15 / scrollView.bounds.height),
                    uiViewStat.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6),
                ])

                uiViewStat.addSubview(data)
                
                let stat = CGFloat(stat.baseStat <= 100 ? stat.baseStat : 100)
                
                NSLayoutConstraint.activate([
                    data.topAnchor.constraint(equalTo: uiViewStat.topAnchor),
                    data.widthAnchor.constraint(equalTo: uiViewStat.widthAnchor,multiplier: (stat * 0.1) / 10),
                    data.heightAnchor.constraint(equalTo: uiViewStat.heightAnchor),
                ])

                NSLayoutConstraint.activate([
                    dataStat.widthAnchor.constraint(equalTo: uiViewStat.widthAnchor, multiplier: 0.4)
                ])
            }
        }
    }
    
    init(pokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        self.pokemon = pokemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapSavePokemon() {
        if let pokemon = pokemon {
            DatabaseManager.shared.addPokemon(pokemon: pokemon) { [weak self] (result) in
                guard let self = self else { return }
                let alert = UIAlertController(title: "Notification",
                                              message: result,
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func didTapDismiss() {
        dismissDetail(duration: 0.2, type: .fromLeft)
    }
    
    func configureImagePokemon(completion: @escaping (UIImage?) -> Void) {
        guard
            let pokemon = pokemon,
            let id = pokemon.id,
            let sprites = pokemon.sprites
        else { return }
        
        if let cachedImage = App.Cache.cacheImage.object(forKey: NSNumber(value: id)) {
            imagePokemon.image = cachedImage
        }
        
        //configure url image pokemon
        let keyCache = NSNumber(value: id)
        
        if let cachedImage = App.Cache.cacheImage.object(forKey: keyCache) {
            imagePokemon.image = cachedImage
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            guard let url = URL(string: sprites.frontDefault) else { return }
            
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    App.Cache.cacheImage.setObject(image, forKey: keyCache)
                    completion(image)
                }
            }
        }
    }
}

extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let pokemon = pokemon,
            let types = pokemon.types,
            let pokemonType = types.first
        else { return }
        
        let positionY = scrollView.contentOffset.y
        
        if positionY >= 0 {
            scrollView.backgroundColor = App.Color.backgroundColor
        } else {
            scrollView.backgroundColor = pokemonType.type.name.backgroundColor
            contentView.backgroundColor = App.Color.backgroundColor
        }
    }
}
