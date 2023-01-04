import { Controller } from '@hotwired/stimulus';
import { DirectUpload } from '@rails/activestorage';
import Dropzone from 'dropzone';
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter,
} from '../helpers/utils';

export default class extends Controller {
  static get targets() {
    return ['input'];
  }

  async connect() {
    Dropzone.autoDiscover = false;

    this.dropzone = createDropzone(this);
    this.hideFileInput();
    this.bindEvents();
  }

  hideFileInput() {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = 'none';
  }

  bindEvents() {
    this.dropzone.on('addedfile', file => {
      setTimeout(() => {
        file.accepted && createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropzone.on('removedfile', file => {
      file.controller && removeElement(file.controller.hiddenInput);
    });

    this.dropzone.on('canceled', file => {
      file.controller && file.controller.xhr.abort();
    });
  }

  get headers() {
    return { 'X-CSRF-Token': getMetaValue('csrf-token') };
  }

  get url() {
    return this.inputTarget.getAttribute('data-direct-upload-url');
  }

  get maxFiles() {
    return this.data.get('maxFiles') || 1;
  }

  get maxFileSize() {
    return this.data.get('maxFileSize') || 1;
  }

  get acceptedFiles() {
    return this.data.get('acceptedFiles') || '.csv';
  }

  get addRemoveLinks() {
    return this.data.get('addRemoveLinks') || true;
  }
}

class DirectUploadController {
  constructor(source, file) {
    this.directUpload = createDirectUpload(file, source.url, this);
    this.source = source;
    this.file = file;
  }

  start() {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput);
        this.emitDropzoneError(error);
      } else {
        this.hiddenInput.value = attributes.signed_id;
        this.emitDropzoneSuccess();
      }
    });
  }

  createHiddenInput() {
    const input = document.createElement('input');
    input.type = 'hidden';
    input.name = this.source.inputTarget.name;
    insertAfter(input, this.source.inputTarget);
    return input;
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr);
    this.emitDropzoneUploading();
  }

  bindProgressEvent(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener('progress', event =>
      this.uploadRequestDidProgress(event)
    );
  }

  uploadRequestDidProgress(event) {
    const progress = (event.loaded / event.total) * 100;
    findElement(
      this.file.previewTemplate,
      '.dz-upload'
    ).style.width = `${progress}%`;
  }

  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING;
    this.source.dropzone.emit('processing', this.file);
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR;
    this.source.dropzone.emit('error', this.file, error);
    this.source.dropzone.emit('complete', this.file);
  }

  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS;
    this.source.dropzone.emit('success', this.file);
    this.source.dropzone.emit('complete', this.file);
  }
}

function createDirectUploadController(source, file) {
  return new DirectUploadController(source, file);
}

function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller);
}

function createDropzone(controller) {
  return new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
  });
}
