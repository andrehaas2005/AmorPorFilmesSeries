//
//  Observable.swift
//  PaixaoPorFilmesESeries
//
//  Created by Andre  Haas on 28/05/25.
//

import Foundation

class SignUpViewModel {
    let errorMessage = Observable<String?>(nil)
    let isLoading = Observable<Bool>(false)
    let signUpSuccess = Observable<Bool>(false)
    let genres = Observable<[Genre]?>(nil) // Lista de todos os gêneros disponíveis
    let selectedGenres = Observable<Set<Genre>?>(Set<Genre>()) // Gêneros que o usuário selecionou
    
    weak var coordinator: SignUpCoordinator?
    private let userService: UserService // Serviço para registro de usuário
    private let genreService: GenreServiceProtocol // NOVO: Serviço para buscar gêneros
    
    // Injeção de dependência para ambos os serviços.
    init(userService: UserService, genreService: GenreServiceProtocol) {
        self.userService = userService
        self.genreService = genreService
    }
    
    /// Busca a lista de gêneros usando o `genreService`.
    func fetchGenres() {
        isLoading.value = true
        genreService.fetchGenres { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading.value = false
                switch result {
                case .success(let fetchedGenres):
                    self?.genres.value = fetchedGenres
                case .failure(let error):
                    self?.errorMessage.value = "Erro ao carregar gêneros: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// Alterna a seleção de um gênero.
    func toggleGenreSelection(_ genre: Genre) {
        
        guard var currentSelection = selectedGenres.value,
              let genreSet = genres.value, let teste = genreSet,
              let selected = currentSelection?.contains(teste) else {
            return
        }
        
        if selected {
            currentSelection?.remove(genre)
        } else {
            currentSelection?.insert(genre)
        }
        selectedGenres.value = currentSelection
    }
    
    
    /// Tenta registrar o usuário com os dados fornecidos.
    func signUp(email: String?, password: String?, passwordConfirmation: String?, name: String?, nickname: String?) {
        guard let email = email, !email.isEmpty,
              let password = password, !password.isEmpty,
              let passwordConfirmation = passwordConfirmation, !passwordConfirmation.isEmpty,
              let name = name, !name.isEmpty,
              let nickname = nickname, !nickname.isEmpty else {
            errorMessage.value = "Por favor, preencha todos os campos."
            return
        }
        
        guard password == passwordConfirmation else {
            errorMessage.value = "As senhas não coincidem."
            return
        }
        
        // Verifica se pelo menos um gênero foi selecionado.
        guard let selectedGenresArray = selectedGenres.value??.sorted(by: { $0.name < $1.name }), !selectedGenresArray.isEmpty else {
            errorMessage.value = "Selecione pelo menos um gênero."
            return
        }
        
        isLoading.value = true
        let newUser = User(email: email, name: name, nickname: nickname, preferredGenres: selectedGenresArray)
        userService.registerUser(user: newUser, passwordConfirmation: passwordConfirmation) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading.value = false
                switch result {
                case .success(let registeredUser):
                    self?.signUpSuccess.value = true
                    self?.coordinator?.didSignUp(email: registeredUser.email)
                case .failure(let error):
                    self?.errorMessage.value = error.localizedDescription
                }
            }
        }
    }
    
    /// Notifica o coordenador para navegar para a tela de login.
    func navigateToSignIn() {
        coordinator?.showSignIn()
    }
}
