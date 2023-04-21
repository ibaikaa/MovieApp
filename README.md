# **MovieApp**

## _Техническое задание на позицию Intern iOS Developer в компанию GeekStudio_.

## *Структура проекта*: 

### **API**: https://imdb-api.com/api#Top250Movies-header

### **Основные библиотеки**: Alamofire, RxSwift, CoreData.

### **Верстка**: SnapKit, UIKit (программная).

### **Архитектура проекта**: MVVM.

### **Дополнительно**: Cosmos, Lottie, Kingfisher.

## *Основа дизайна*: 
1. https://dribbble.com/shots/5529233-Movie-App-Interface-Design-Dark-Theme

2.  https://dribbble.com/shots/15130805-Cinema-Booking-App

## **‼️ Внимание ‼️**:
> API-ключ для IMDb API позволяет сделать ограниченное количество запросов в день: 100 (бесплатный тариф). После этого, выдачи положительного ответа с данными по вашему запросу уже не будет. 

## О проекте: 

### *Проект является мини-приложением для доступа к информации о ТОП-250 фильмах с IMDb. Используется публичная API от IMDB (см. выше) для получения данных. Для реактивной работы используется **RxSwift** и для UI-элементов RxCocoa.*  

### Описание проекта: 
1. **Главная страница**. 
> На главной странице имеется список из 250 фильмов в виде скроллящейся вниз коллекции, поисковик по фильмам, сделанный также на Rx. При нажатии на ячейку коллекции отображается детальная страница. 
> В случае, если нет интернет-соединения и список фильмов не отображен, появляется кнопка "Try again". 
> При загрузке появляется индикатор загрузки.

2. **Детальная страница**. 
> На детальной странице имеются данные о выбранном фильме. 
> В правом верхнем углу есть анимированная кастомная кнопка "❤️", отвечающая за добавление фильма в избранное, либо же его удаление. При нажатии на кнопку данные либо о фильме, который нужно добавить в избранное, сохраняются в _CoreData_, либо удаляются из нее. 
> Также, присутствует кнопка "Watch trailer", которая открывает окно Safari, веб-страницу YouTube для просмотра трейлера к фильму. Данные к URL-ссылке к трейлеру фильма также берутся с API.

3. **Избранные фильмы**.
> Все фильмы добавляются в избранное через CoreData. 

> В случае, если нет избранных фильмов, будет видна анимация и соответствующее изображение. 

> Список избранных фильмов также вытягивается через _RxSwift_ и отображается в коллекции через _RxCocoa_.

> При нажатии на фильм из коллекции также появляется детальное описание. 

 
