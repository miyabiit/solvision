<template>
  <div>
    <a @click="toggle">
      <i class="material-icons mdc-toolbar__menu-icon">menu</i>
    </a>
    <aside id="menu_drawer" class="mdc-drawer mdc-drawer--temporary">
      <nav class="mdc-drawer__drawer">
        <div class="mdc-list-group">
          <nav class="mdc-list">
            <a href="/facilities"class="mdc-list-item" data-mdc-tabindex-handled="true" tabindex="-1">
              <i class="material-icons mdc-list-item__start-detail" style="color: black !important" aria-hidden="true">brightness_low</i>&nbsp;発電施設
            </a>
            <a href="/monthly_receipts"class="mdc-list-item" data-mdc-tabindex-handled="true" tabindex="-1">
              <i class="material-icons mdc-list-item__start-detail" style="color: black !important" aria-hidden="true">receipt</i>&nbsp;入金実績
            </a>
            <a href="/analysis"class="mdc-list-item" data-mdc-tabindex-handled="true" tabindex="-1">
              <i class="material-icons mdc-list-item__start-detail" style="color: black !important" aria-hidden="true">timeline</i>&nbsp;事業分析
            </a>
          </nav>
          <hr class="mdc-list-divider">
          <nav class="mdc-list">
            <a rel="nofollow" data-method="delete" href="/users/sign_out"class="mdc-list-item" data-mdc-tabindex-handled="true" tabindex="-1">
              <i class="material-icons mdc-list-item__start-detail" style="color: black !important" aria-hidden="true">exit_to_app</i>&nbsp;ログアウト
            </a>
          </nav>
        </div>
      </nav>
    </aside>
  </div>
</template>

<script>
import {MDCTemporaryDrawer, MDCTemporaryDrawerFoundation, util} from '@material/drawer';

export default {
  props: {
    title: String
  },
  data() {
    return {
      drawer: null
    }
  },
  methods: {
    toggle() {
      if (!this.drawer) {
        this.drawer = new MDCTemporaryDrawer(document.getElementById('menu_drawer'));
      }
      this.drawer.open = !this.drawer.open
    }
  }
}
</script>
