# Cách Triển Khai Viết Tài Liệu API DOTB

Hướng dẫn này mô tả cách clone, cài đặt, chỉnh sửa và build tài liệu API sử dụng `openapi.yaml` với Redocly CLI.

---

## Yêu cầu

* Git
* Node.js
* Redocly CLI (`npm install -g @redocly/cli`)

---

## Bước 1: Clone source về máy

```bash
git clone <URL_repository>
cd <thư_mục_repository>
```

## Bước 2: Tải dependencies

```bash
npm install
```

## Bước 3: Chỉnh sửa và preview tài liệu

1. Mở và chỉnh sửa file cấu hình OpenAPI:

   ```
   openapi/openapi.yaml
   ```
2. Chuyển vào thư mục chứa file OpenAPI:

   ```bash
   cd openapi
   ```
3. Build tài liệu thành bundle:

   ```bash
   redocly bundle openapi.yaml --output bundled.yaml
   ```
4. Preview tài liệu từ bundle:

   ```bash
   redocly preview-docs bundled.yaml
   ```

   Sau khi chạy lệnh, bạn sẽ thấy kết quả tương tự:

   ```text
   Using Redoc community edition.
   Login with redocly login or use an enterprise license key to preview
   with the premium docs.

     🔎  Preview server running at http://127.0.0.1:8080

   Bundling...

     👀  Watching bundled.yaml and all related resources for changes  

   Created a bundle for bundled.yaml successfully
   ```
5. Truy cập đường dẫn [http://127.0.0.1:8080](http://127.0.0.1:8080) để xem tài liệu.

---

## Bước 4: Build và deploy tài liệu

1. Sau khi hoàn tất chỉnh sửa, chuyển vào thư mục `docs/`:

   ```bash
   cd ../docs
   ```
2. Tạo file `dist.json` từ source OpenAPI:

   ```bash
   redocly bundle ../openapi/openapi.yaml -o dist.json
   ```
3. Deploy tài liệu: build toàn bộ thư mục `docs/` lên server hoặc GitHub Pages.

---

## Tham khảo

* Hướng dẫn gốc: [A Guide to Creating API Documentation with Redoc and GitHub Pages](https://dev.to/heymich/a-guide-to-creating-api-documentation-with-redoc-and-github-pages-4i4a)
