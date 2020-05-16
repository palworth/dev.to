import { h, render } from 'preact';
import { getUserDataAndCsrfToken } from '../chat/util';
import { CollectionList } from '../collectionList/collectionList';

function loadElement() {
  getUserDataAndCsrfToken().then(({ currentUser }) => {
    const root = document.getElementById('reading-list');
    const { collection } = root.dataset;
    if (root) {
      render(
        <CollectionList
          availableTags={currentUser.followed_tag_names}
          statusView={root.dataset.view}
          collection={JSON.parse(collection)}
          currentUser={currentUser}
        />,
        root,
        root.firstElementChild,
      );
    }
  });
}

window.InstantClick.on('change', () => {
  loadElement();
});

loadElement();
