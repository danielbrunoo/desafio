# Desafio técnico em Flutter

## Objetivo

**O objetivo é criar a parte inicial de um aplicativo simples, com apenas 2 telas.**

**A ideia é que esse aplicativo cresça futuramente com novos recursos e novas telas.**

A proposta é validar a lógica e principalmente a forma como resolveu o problema.

Vamos querer ouvir como aprendeu, como descobriu e o porquê escolheu fazer assim no seu código.

Não é necessário conhecer todos recursos para resolver o desafio, a proposta é _"correr atrás"_ para aprender e então resolver caso não saiba de algo.

Sugerimos procurar no Google, Stack Overflow, YouTube, grupos técnicos, amigos, colegas de sala, professor, o que preferir, inclusive IA 🤖 -- _só lembra de contar pra gente depois hein!_ 📣

Para que todos possam fazer no melhor horário de cada um, vamos dar o prazo de 1 semana, faça no horário que preferir.


## Problema a ser resolvido

Criar um aplicativo em Flutter com duas telas, uma para validar uma senha e a outra para exibir a mensagem de sucesso vinda da API, caso a senha seja válida.

1. O usuário tem um campo de inserir uma senha e enviar para uma API validar.
2. Somente se a resposta da API for sucesso, levar o usuário para outra tela com a mensagem de resposta do servidor.


Para uma senha ser forte, ela deve ter:

- no mínimo 8 caracteres
- pelo menos um número
- pelo menos uma letra maiúscula
- pelo menos uma letra minúscula
- pelo menos um caracter especial


### Exemplos de algumas senhas fortes

- `#eforTe1`
- `Voce@Consegue!2024`
- `A8fd10e8-4194-488d-aa8b-e53f6a044802`
- `kygjok-xuQxih-coqmu2`


## API

[![Powered by Dart Frog](https://img.shields.io/endpoint?url=https://tinyurl.com/dartfrog-badge)](https://dartfrog.vgv.dev)

Foi criada uma API especificamente para esse desafio.

O objetivo dela é fornecer os recursos necessários para esta solução, para que você possa focar exclusivamente no aplicativo em Flutter.

Tem a documentação via Swagger disponível aqui: [https://desafioflutter-api.modelviewlabs.com/swagger](https://desafioflutter-api.modelviewlabs.com/swagger)

Os principais endpoints são esses:

### `GET` https://desafioflutter-api.modelviewlabs.com/random

> [200] Exemplo de resposta

```json
{"password":"c1453dDa-5d84-46d5-99f8-8afd05b3b8be"}
```

### `POST` https://desafioflutter-api.modelviewlabs.com/validate

> Exemplo de requisição

```json
{"password":"c1453dDa-5d84-46d5-99f8-8afd05b3b8be"}
````

> [202] Exemplo de resposta com sucesso

```json
{"id": "id", "message": "Senha válida..."}
```

### Considerações

Só que ela tem algumas características:

- Eventualmente vai dar alguns erros intencionais 😅, portanto prepare-se para recebê-los. Basta tentar novamente quando acontecer.
- Ela tem uns atrasos intencionais e aleatórios também, onde pode demorar de 0 a 5 segundos ⌛️


---


## Boa sorte! 😉
