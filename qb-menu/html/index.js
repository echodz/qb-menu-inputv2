let menuOpen = false;
let buttonParams = [];
let originalMenuData = [];
let menuItems = [];

window.addEventListener('message', function(event) {
    ed = event.data;
    if (ed.action === "SET_STYLE") {
        if (ed.themeColor) {
            document.documentElement.style.setProperty('--Theme-Color', ed.themeColor);
            // Calculate shadow color from theme color
            const shadowColor = ed.themeColor.replace('#', '').match(/.{2}/g).map(x => parseInt(x, 16)).join(', ');
            document.documentElement.style.setProperty('--Theme-Color-Shadow', `rgba(${shadowColor}, 0.8)`);
        }
    }
    if (ed.action === "openMenu") {
        if (ed.themeColor) {
            document.documentElement.style.setProperty('--Theme-Color', ed.themeColor);
            // Calculate shadow color from theme color
            const shadowColor = ed.themeColor.replace('#', '').match(/.{2}/g).map(x => parseInt(x, 16)).join(', ');
            document.documentElement.style.setProperty('--Theme-Color-Shadow', `rgba(${shadowColor}, 0.8)`);
        }
        originalMenuData = ed.data.filter(item => !item.hidden);
        let html = '<input id="searchBar" type="text" placeholder="Search...">';
        originalMenuData.forEach((item, index) => {
            let header = item.header;
            let message = item.txt || item.text;
            let isMenuHeader = item.isMenuHeader;
            let isDisabled = item.disabled;
            let icon = item.icon;
            html += getButtonRender(header, message, index, isMenuHeader, isDisabled, icon);
            if (item.params) buttonParams[index] = item.params;
        });
        $("#mainDivMenus").html(html);
        menuItems = $('.mainDivMenuDiv');
        $('.mainDivMenuDiv').click(function() {
            const target = $(this);
            postData(target.attr('id'));
        });
        menuOpen = true;
        document.getElementById("mainDiv").style.display = "flex";
        $('#searchBar').on('input', function() {
            const searchTerm = $(this).val().toLowerCase();
            menuItems.each(function() {
                const header = $(this).find('h4').text().toLowerCase();
                const message = $(this).find('span').text().toLowerCase();
                if (header.includes(searchTerm) || message.includes(searchTerm)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        });
    } else if (ed.action === "closeMenu") {
        $("#mainDivMenus").html('<input id="searchBar" type="text" placeholder="Search...">');
        buttonParams = [];
        menuOpen = false;
        document.getElementById("mainDiv").style.display = "none";
    }
    document.onkeyup = function(data) {
        if (data.which == 27 && menuOpen) {
            menuOpen = false;
            document.getElementById("mainDiv").style.display = "none";
            $.post(`https://${GetParentResourceName()}/closeMenu`);
        }
    }
});

const getButtonRender = (header, message, id, isMenuHeader, isDisabled, icon) => {
    let divClass = "mainDivMenuDiv";
    if (isDisabled) { divClass = "mainDivMenuDivDisabled"; }
    if (isMenuHeader) { divClass = "mainDivMenuDivHeader"; }
    if (icon) {
        if (message) {
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivIconDiv"><i class="${icon}"></i></div>
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4><span>${message}</span></div>
            </div>
            `;
        } else if (isDisabled) {
            divClass = "mainDivMenuDivDisabled";
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivIconDiv"><i class="${icon}"></i></div>
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4></div>
            </div>
            `;
        } else {
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivIconDiv"><i class="${icon}"></i></div>
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4></div>
            </div>
            `;
        }
    } else {
        if (message) {
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4><span>${message}</span></div>
            </div>
            `;
        } else if (isDisabled) {
            divClass = "mainDivMenuDivDisabled";
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4></div>
            </div>
            `;
        } else {
            return `
            <div class="${divClass}" id="${id}">
                <div id="mainDivMenuDivTextsDiv"><h4>${header}</h4></div>
            </div>
            `;
        }
    }
};

const closeMenu = () => {
    $("#mainDivMenus").html('<input id="searchBar" type="text" placeholder="Search...">');
    buttonParams = [];
    menuOpen = false;
    document.getElementById("mainDiv").style.display = "none";
};

const postData = (id) => {
    $.post(`https://${GetParentResourceName()}/clickedButton`, JSON.stringify(parseInt(id) + 1));
    return closeMenu();
};

function appendHtml(el, str) {
    var div = document.createElement('div');
    div.innerHTML = str;
    while (div.children.length > 0) {
        el.appendChild(div.children[0]);
    }
}