(function($, undefined) {
  class SelectInput {
    // Everything that has a '$' is a jQuery search item
    constructor(componentId) {
      this.$component = $("#"+componentId);

      this.$selectItemButton =  this.$component.find('.select-input-button span');
      this.$container = this.$component.find('.select-input-container');
      this.$ul = this.$component.find('.select-input-list ul');
      this.$searchField = this.$component.find('.select-input-field input[type=text]');
      this.$submitValue = this.$component.find('.select-input-field input[type=hidden]');
      this.list = this.$ul.children('li').map((i, item) => {
        let $item = $(item);

        return {
          id: $item.data('id'),
          text: $item.text()
        }
      });

      this.$selectItemButton.on('click', this.toggleListEvent.bind(this));
      this.$searchField.on('keyup', this.filterListEvent.bind(this));
      this.$ul.children('li').on('click', this.selectListItemOnClickEvent.bind(this));
    }

    setListData(listData) {
      let itens = [];

      if (listData !== undefined) {
          itens = listData;
      } else {
          itens = this.list;
      }

      this.$ul.empty();

      [].forEach.call(itens, (item) => {
          this.$ul.append(`<li data-id="${item.id}">${item.text}</li>`);
      });

      this.$ul.children('li').on('click', this.selectListItemOnClickEvent.bind(this));
    }

    toggleListEvent(e) {
      this.$container.toggle();
    }

    selectListItemOnClickEvent(e) {
      let text = e.target.textContent.trim();
      this.$selectItemButton.text(text);
      this.$container.toggle();

      this.$searchField.val(text);
      this.$submitValue.val(e.target.getAttribute('data-id'));
    }

    filterListEvent(e) {
      let text = e.target.value.trim();

      if (text.length >= 3) {
        let regex = new RegExp(".*" + text + ".*", "i");
        let filteredList = this.list.filter((i, item) => regex.test(item.text));

        if (filteredList.length !== 0) {
          this.setListData(filteredList);
        }
      } else {
       this.setListData();
      }
    }
  }

  window.noosfero = window.noosfero || {};
  window.noosfero.SelectInput = SelectInput;
}) (jQuery);
