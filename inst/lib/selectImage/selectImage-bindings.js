const selectImageBinding = new Shiny.InputBinding();

$.extend(selectImageBinding, {
    find: function(scope) {
        return $(scope).find('.dropdown');
    },
    initialize: function(el) {
        const container = document.createElement('div');
        container.setAttribute('class', 'dropdown-container');
        el.appendChild(container);

        createDropdownSelector(container);
        createDropdownOptions(el, container);
    },
    getValue: function(el) {
        return el.dataset.selected;
    },
    subscribe: function(el, callback) {
        const placeholder = el.querySelector('.dropdown-placeholder');

        el.addEventListener('click', function(event) {
            const target = event.target;
            if (target === this) {
                return;
            }
            if (
                target.matches('.dropdown-option') ||
                target.parentNode.matches('.dropdown-option')
            ) {
                const node = target.matches('.dropdown-option') ?
                    target :
                    target.parentNode;
                const html = node.innerHTML;
                placeholder.innerHTML = html;
                el.dataset.selected = node.dataset.option;
            }
            this.classList.toggle('opened');
            callback();
        });
    },
    receiveMessage: function(el, message) {
        const elData = JSON.parse(el.dataset.options);
        // Default data rendered in DOM
        let options = elData
            .map(function(item) {
                return { id: item.id, label: item.label };
            })
            .filter(function(item) {
                return item;
            });
        let images = elData
            .map(function(item) {
                return { image: item.image };
            })
            .filter(function(item) {
                return item;
            });


        if (message.selected) {
            const target = el.querySelector('#' + message.selected);
            $(target).trigger('click');
            el.classList.remove('opened');
        }
        if (message.hasOwnProperty('choices')) {
            // choices should be an array or an object
            if (Array.isArray(message.choices)) {
                options = message.choices.map(function(choice) {
                    return { id: choice, label: choice };
                });
            } else {
                // TODO: check if choices is an object
                options = Object.keys(message.choices).map(function(key) {
                    return { id: message.choices[key], label: key };
                });
            }
        }
        // Images must be set, otherwise, what's the point
        if (message.hasOwnProperty('images')) {
            images = Object.keys(message.images).map(function(key) {
                return { image: message.images[key] };
            });
        }
        // if (message.hasOwnProperty('images')) {
        //   images = message.images.map(function (image) {
        //     return { image: image };
        //   });
        // }
        // merge options and images if the length of both is the same
        if (options.length) {
            const optionsData = zip(options, images);
            const optionsListItems = getDropdownOptions(el, optionsData);
            // console.log("optionsListItems", optionsListItems);
            const optionsListContainer = el.querySelector('.dropdown-options');
            optionsListContainer.innerHTML = '';
            for (const option of optionsListItems) {
                optionsListContainer.appendChild(option);
            }
            const selected = message.selected || options[0].id;
            // console.log("message.selected", message.selected)
            // console.log("selected", selected)
            const target = el.querySelector('#' + selected);
            $(target).trigger('click');
            el.classList.remove('opened');
        }
    },
});

function createDropdownSelector(el) {
    const select = document.createElement('div');
    const placeholder = document.createElement('div');
    const chevron =
        '<svg fill="none" width="16" height="16" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" /></svg>';

    select.setAttribute('class', 'dropdown-select');
    placeholder.setAttribute('class', 'dropdown-placeholder');

    select.appendChild(placeholder);
    select.innerHTML = select.innerHTML + chevron;

    el.appendChild(select);
}

function createDropdownOptions(el, container) {
    let optionsData;
    try {
        optionsData = JSON.parse(el.dataset.options);
    } catch (error) {
        optionsData = [];
    }
    const optionsListContainer = document.createElement('ul');
    const optionsListItems = getDropdownOptions(el, optionsData);

    for (const option of optionsListItems) {
        optionsListContainer.appendChild(option);
    }

    optionsListContainer.setAttribute('class', 'dropdown-options');
    container.appendChild(optionsListContainer);
}

function getDropdownOptions(el, optionsData) {
    updateAttrs(el, optionsData);
    const placeholder = el.querySelector('.dropdown-placeholder');
    const options = optionsData.map(function(option) {
        const li =
            el.querySelector('#' + option.id) || document.createElement('li');
        const image = li.querySelector('img') || document.createElement('img');
        const span = li.querySelector('span') || document.createElement('span');

        image.setAttribute('src', option.image);
        span.textContent = option.label;

        li.dataset.option = option.id;
        li.setAttribute('class', 'dropdown-option');
        li.setAttribute('id', option.id);

        option.image && li.appendChild(image);
        option.label && li.appendChild(span);

        if (el.dataset.selected && el.dataset.selected === option.id) {
            placeholder.innerHTML = li.innerHTML;
        }

        return li;
    });

    return options.filter(function(option) {
        return option;
    });
}

function updateAttrs(el, optionsData) {
    const elOptions = JSON.parse(el.dataset.options);
    const optionsDataStringified = JSON.stringify(optionsData);

    // Update data-options if needed
    if (!elOptions.length) {
        el.dataset.options = optionsDataStringified;
    } else if (el.dataset.options !== optionsDataStringified) {
        el.dataset.options = optionsDataStringified;
    }

    // Set data-selected attribute if missing
    if (!el.dataset.selected) {
        el.dataset.selected = optionsData.length ? optionsData[0].id : '';
    }
}

/*
 * Example
 * a = [{ number: 1 }, { number: 2 }, { number: 3 }]
 * b = [{ letter: 'a' }, { letter: 'b' }, { letter: 'c' }]
 * zip(a, b) = [{ number: 1, letter: 'a' }, { number: 2, letter: 'b' }, { number: 3, letter: 'c' }]
 */
function zip(a, b) {
    return a.map(function(item, index) {
        return Object.assign({}, item, b[index]);
    });
}

Shiny.inputBindings.register(selectImageBinding, 'shiny.selectImageInput');