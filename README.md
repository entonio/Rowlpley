# Rowlpley

Rowlpley is an RPG character sheet app.
The gist is for users to keep a record of the data that depends on them and the gameplay, while the app instantly performs any related calculations and displays every game element that follows from that.

Currently, the focus is on full support for the [Ordem Paranormal](https://ordemparanormal.com.br/) system.
Other systems may follow, the next one probably being [Dungeons & Dragons, 5th edition](https://dnd.wizards.com/).

While some parts of the mechanics of each system have to be coded into the app, most of the data is loaded from `xlsx` files. This will eventually allow the app to support different variants of the same system, sharing the minimals but having different data.

This is not a commercial app, and one of the constraints is not to infringe on any copyright, only doing what is allowed under fair use and community licensing. If you find that any material is in violation of your copyright, please say which and ask for its removal.

## Dungeons & Dragons, 5th edition

The _Dungeons & Dragons, 5th edition_ system is copyright of Wizards of the Coast and its use is regulated by the [Open Game License](https://en.wikipedia.org/wiki/Open_Game_License#5th_Edition).

## Ordem Paranormal

The _Ordem Paranormal_ system is copyright of [Jambô Editora](https://jamboeditora.com.br/). Its _Livro de Regras_ closing notice indicates what parts are restricted, while the rest can be used under the [Open Game License v1.0a](https://en.wikipedia.org/wiki/Open_Game_License). In that context, the Product Identity is described as

> os capítulos 5, 7 e 8, todos os termos referentes ao cenário de Ordem Paranormal, incluindo a Membrana, o Outro Lado, nomes e descrições de personagens, criaturas, entidades, lugares e organizações, todas as ilustrações e todas as regras de rituais, poderes paranormais, Sanidade e dano mental.

As such, none of those elements are present in this app.

Pending further validation, all other elements of the system, except the bare minimum, are not included either, and the app has to load them from a set of `xlsx` files that are not in this repository.

## Features

The app leverages SwiftUI to provide an adaptive layout according to the device.
The next examples are of the iPad mini in landscape mode.

Startup and color schemes (system, light, dark):

https://github.com/entonio/Rowlpley/assets/5048472/34488786-3deb-4225-bf41-404f22fe50e8

Creating a new character:

https://github.com/entonio/Rowlpley/assets/5048472/e795c56b-f728-4a1b-ba5e-65056bd98311

Managing the list of characters:

https://github.com/entonio/Rowlpley/assets/5048472/9b5740ab-8cf2-418b-9ab9-87fcde109415

Editing a character:

https://github.com/entonio/Rowlpley/assets/5048472/9310068b-faf9-4532-b52f-91b06a120e0d

Character stats:

https://github.com/entonio/Rowlpley/assets/5048472/7b231595-9a86-43ee-8b98-d41eb0fe80a4

This is how the app works on the iPhone SE:

https://github.com/entonio/Rowlpley/assets/5048472/c3df1fce-1453-4406-acc2-29bf2b600129

## Roadmap

Ongoing developments:

- Adding items to characters
- Display resistances / DTs / defense

Coming next:

- Improve layout for Larger Text mode and similar cases
- Character sharing from the character view

Further on:

- Switch from character export to character sharing
- Split View
- Multitasking

## Other purposes

Having a character sheet manager is in itself a valuable goal for the author, but at the same time it's a learning experiment on a number of topics:

- SwiftData
- Accessibility
- Simple encryption
- Making the playing systems and part of their logic loadable
- Document sharing
- [Thumbnail Extension](https://stackoverflow.com/questions/58468996/ios-13-thumbnail-extension-qlthumbnailprovider-not-being-called/78551546#78551546)
- The best way(s) to structure a SwiftUI app (still ongoing, almost everything seems to turn out acceptable)
- Multiple window app / Multitasking / Split View (TBD)

## License

Except where/if otherwise specified, all the files in this app are copyright of the app contributors mentioned in the `NOTICE` file and licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0).
